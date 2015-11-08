module Typhoon
  class Server
    def initialize(host, port)
      puts "Listening on #{host}:#{port}"
      @selector = NIO::Selector.new
      @server = TCPServer.new(host, port)
      @selector.register(@server, :r)
      @connections = Hash.new { |h, k| h[k] = Connection.new(k, self) }
    end

    def on_connection(connection)
    end

    def run
      loop do
        @selector.select do |monitor|
          case monitor.io
          when TCPServer
            on_server(monitor)
          when TCPSocket
            on_socket(monitor)
          end
        end
      end
    end

    def on_server(monitor)
      socket = monitor.io.accept
      @selector.register(socket, :r)
    end

    def on_socket(monitor)
      socket = monitor.io
      data = socket.read_nonblock(4096)
      connection = @connections[socket]
      connection.parser << data
      on_connection(connection)
      connection << response(200, "<div>hello</div>")
      cleanup(socket) unless connection.websocket?
    rescue EOFError
      cleanup(socket)
    end

    def cleanup(socket)
      @selector.deregister(socket)
      @connections.delete(socket)
      socket.close
    end

    def response(status=200, body=nil, headers=nil)
      msg = "HTTP/1.1 #{status} #{Rack::Utils::HTTP_STATUS_CODES[status]}\r\n"
      msg << "Connection: Keep-Alive\r\n"
      if body
        msg << "Content-Length: #{body.length}\r\n"
        msg << "\r\n"
        msg << body
      end
      msg << "\r\n"
    end
  end
end
