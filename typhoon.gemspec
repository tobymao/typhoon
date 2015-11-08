Gem::Specification.new do |s|
  s.name        = 'typhoon'
  s.version     = '0.1.0'
  s.date        = '2015-11-05'
  s.summary     = "Typhoon is a fast evented web server intended for websocket applications. It has minimal HTTP support."
  s.description = "Evented web server"
  s.authors     = ["Toby Mao"]
  s.email       = 'toby.mao@gmail.com'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://github.com/tobymao/typhoon'
  s.license     = 'MIT'

  s.add_dependency 'nio4r', '~> 1.1'
  s.add_dependency 'rack', '~> 1.6'
  s.add_dependency 'websocket-driver', '~> 0.6'
  s.add_dependency 'http_parser.rb', '~> 0.6'
  s.add_dependency 'require_all', '~> 1.3'
end
