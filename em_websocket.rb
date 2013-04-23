require 'em-websocket'
require 'json'

def symbolize_keys(hash)
  hash.inject({}){|new_hash, key_value|
    key, value = key_value
    value = symbolize_keys(value) if value.is_a?(Hash)
    new_hash[key.to_sym] = value
    new_hash
  }
end

EM.run {
    @sockets = Array.new
    @rooms = Hash.new
    
    EM::WebSocket.start(:host=>'0.0.0.0',:port=>8080) do |ws|
      ws.onopen do
        
      end

      ws.onclose do
      end
    
      ws.onmessage do |msg|
      begin
        #client = JSON.parse(msg).symbolize_keys
        client = JSON.parse(msg)
	client = symbolize_keys(client)
	room = client[:room]
        case client[:action]
        when 'connect'
	  @rooms[room] ||= []
	  @rooms[room] << ws
        when 'say'
          @rooms[room].each do |s|
		s.send(msg)
          end
        when 'teacher'
          @rooms[room].each do |s|
		s.send(msg)
          end
        end
      rescue  Exception =>e
	puts e
      end
      end
    end
  
}
