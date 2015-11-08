module Typhoon
  class Connection
    attr_reader :socket, :parser, :driver

    def initialize(socket, delegate)
      @socket = socket
      @parser = Http::Parser.new(self)
      @delegate = delegate
    end

    def <<(data)
      if websocket?
        @driver.text(data)
      else
        @socket << data
      end
    end

    def on_message_begin
    end

    def on_headers_complete(headers)
      connection = headers['HTTP_CONNECTION']
      upgrade = headers['HTTP_UPGRADE']

      @websocket =
        (connection && connection.downcase.split(/ *, */).include?('upgrade')) &&
        (upgrade && upgrade.downcase == 'websocket') &&
        headers['REQUEST_METHOD'] == 'GET'

      if @websocket
        @driver = WebSocket::Driver.server(@socket)
        @driver.start
        @driver.on(:message) { |e| @driver.text(e.data) }
        @driver.on(:close) { |e| puts 'on close' }
      end
    end

    def on_body(chunk)
    end

    def on_message_complete
      @complete = true
    end

    def close
      delegate.cleanup(socket)
    end

    def complete?
      @complete
    end

    def websocket?
      @websocket
    end
  end
end
