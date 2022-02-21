require 'faye/websocket'

module Middleware
  class MonopolyBackend
    KEEPALIVE_TIME = 15 # in seconds

    def initialize(app)
      @app     = app
      @clients = []
      @rooms = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

        ws.on :open do |event|
          p [:open, ws.object_id]
          @clients << ws
        end

        ws.on :message do |event|
          websocket_on_message(ws, event)
        end

        ws.on :close do |event|
          p [:close, ws.object_id, event.code, event.reason]
          @clients.delete(ws)
          ws = nil
        end

        # Return async Rack response
        ws.rack_response
      else
        @app.call(env)
      end
    end

    private

    def websocket_on_message(ws, event)
      p [:message, event.data]
      response = {}
      data = JSON.parse(event.data)
      action = data.dig('action')
      username = data.dig('username')
      case action
      when 'join_room'
        p 'joining room'
        code = data.dig('game_code')
        response = {
          action: 'join_room',
          username: username,
          code: code
        }
      when 'create_room'
        p 'creating room'
        room = ::Service::CreateRoom.run!(username)
        @rooms << room
        response = {
          action: action,
          username: username,
          code: room.code
        }
      else
        raise 'invalid action'
      end
    rescue => e
      p e.message
      p e.backtrace
      action = 'error'
      response = {
        action: 'error'
      }
    ensure
      p response
      ws.send(response.to_json)
    end
  end
end
