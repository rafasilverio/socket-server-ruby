require 'eventmachine'
require 'sinatra/base'
require 'thin'

#instancia servidor
def run(opts)
  EM.run do
    server  = opts[:server] || 'thin'
    host    = opts[:host]   || '0.0.0.0'
    port    = opts[:port]   || '8282'
    web_app = opts[:app]

    dispatch = Rack::Builder.app do
      map '/' do
        run web_app
      end
    end

    unless ['thin', 'hatetepe', 'goliath'].include? server
      raise "webserver: #{server}"
    end

    Rack::Server.start({
      app:    dispatch,
      server: server,
      Host:   host,
      Port:   port
    })
  end
end

class HelloApp < Sinatra::Base
  #multhread
  configure do
    set :threaded, true
  end

  #rotas
  get '/' do
    erb :'hello'
  end

  get '/hello' do
    erb :'hello'
  end

  #trata o 404
  not_found do
    erb :'404'
  end
end

#Inicia aplicação
run app: HelloApp.new
