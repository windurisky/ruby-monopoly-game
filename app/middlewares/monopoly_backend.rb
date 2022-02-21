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
          ws_on_message(ws, event)
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

    def ws_on_message(ws, event)
      p [:message, event.data]
      response = {}
      data = JSON.parse(event.data)
      action = data.dig('action')
      case action
      when 'join_room'
        response = ws_join_room(data)
      when 'create_room'
        response = ws_create_room(data)
      else
        raise 'invalid action'
      end
    rescue => e
      p e.message
      p e.backtrace
      action = 'error'
      response = {
        action: 'error',
        message: e.message
      }
    ensure
      p response
      ws.send(response.to_json)
    end

    def ws_join_room(data)
      p 'joining room'
      action = data.dig('action')
      username = data.dig('username')&.strip
      code = data.dig('game_code')&.strip&.upcase
      room = @rooms.select { |r| r.code == code }.first
      raise 'room not found' if room.nil?
      joined_room = ::Service::JoinRoom.run!(username, room)
      @rooms.map! do |r|
        r.code == room.code ? joined_room : r
      end

      { action: action, username: username, code: code }
    end

    def ws_create_room(data)
      p 'creating room'
      action = data.dig('action')
      username = data.dig('username')&.strip
      room = ::Service::CreateRoom.run!(username)
      raise 'rooms are full, try again later' if @rooms.count >= 5
      @rooms << room

      { action: action, username: username, code: room.code }
    end
  end
end
