require 'faye/websocket'

module Middleware
  class MonopolyBackend
    KEEPALIVE_TIME = 15 # in seconds

    # list of actions
    BROADCAST_MESSAGE = 'broadcast_message'
    CREATE_ROOM = 'create_room'
    JOIN_ROOM = 'join_room'
    CONNECT_ROOM = 'connect_room'

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
      when JOIN_ROOM
        ws_join_room(ws, data)
      when CREATE_ROOM
        ws_create_room(ws, data)
      when CONNECT_ROOM
        ws_connect_room(ws, data)
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
      ws.send(response.to_json)
    end

    def ws_join_room(ws, data)
      p 'joining room'
      action = data.dig('action')
      username = data.dig('username')&.strip
      code = data.dig('room_code')&.strip&.upcase
      room = find_room(code)
      joined_room, player = ::Service::JoinRoom.run!(username, ws, room)
      replace_room(joined_room)

      response = { action: action, user_id: player.user_id, username: username, code: code }
      ws.send(response.to_json)

      message_response = { action: BROADCAST_MESSAGE, message: "#{username} has joined the game!" }
      room.websocket_send(message_response.to_json)
    end

    def ws_create_room(ws, data)
      p 'creating room'
      action = data.dig('action')&.strip
      username = data.dig('username')&.strip
      room, player = ::Service::CreateRoom.run!(username, ws)
      raise 'rooms are full, try again later' if @rooms.count >= ENV.fetch('MAX_ROOMS', 5).to_i
      @rooms << room

      response = { action: action, user_id: player.user_id, username: username, code: room.code }
      ws.send(response.to_json)
    end

    def ws_connect_room(ws, data)
      p 'connecting to room'
      action = data.dig('action')&.strip
      user_id = data.dig('user_id')&.strip
      username = data.dig('username')&.strip
      code = data.dig('room_code')&.strip&.upcase
      room = find_room(code)

      connected_room, player = ::Service::ConnectRoom.run!(user_id, username, room, ws)
      replace_room(connected_room)

      response = { action: action, user_id: player.user_id, username: username, code: room.code }
      ws.send(response.to_json)

      message_response = { action: BROADCAST_MESSAGE, message: "#{username} has been connected to the room!" }
      room.websocket_send(message_response.to_json)
    end

    def find_room(code)
      room = @rooms.select { |r| r.code == code }.first
      raise 'room not found' if room.nil?
      p "room players:"
      p room.players.map { |p| [p.user_id, p.username] }
      room
    end

    def replace_room(updated_room)
      @rooms.map! do |r|
        r.code == updated_room.code ? updated_room : r
      end
    end
  end
end
