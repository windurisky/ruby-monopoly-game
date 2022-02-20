require 'faye/websocket'

module Middleware
  class MonopolyBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })
        # WebSockets logic goes here

        # Return async Rack response
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
