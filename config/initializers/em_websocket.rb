
#escape html/xss
include ERB::Util

Thread.abort_on_exception = true

Thread.new {
  EventMachine.run {
    @sockets = Array.new
    @rooms = Hash.new
    
    EventMachine::WebSocket.start(:host=>'0.0.0.0',:port=>8088) do |ws|
      ws.onopen do
        
      end

      ws.onclose do
        #index = @sockets.index {|i| i[:socket] == ws}
        #client = @sockets.delete_at index
        #@sockets.each {|s| s[:socket].send h("#{client[:id]} has disconnected!")}
        #client = JSON.parse(msg).symbolize_keys
	#room = client[:room]
	  #@rooms[room].delete ws
      end
    
      ws.onmessage do |msg|
        client = JSON.parse(msg).symbolize_keys
	room = client[:room]
        case client[:action]
        when 'connect'
	  @rooms[room] ||= []
	  @rooms[room] << ws
          #@rooms.push({:id=>client[:id], :socket=>ws})
          #@sockets.each {|s| s[:socket].send h("#{client[:id]} has connected!")}
        when 'say'
          puts room
          @rooms[room].each do |s|
		s.send  h("#{client[:id]} : #{client[:data]}")
          end
          #@sockets.each {|s| s[:socket].send h("#{client[:id]} says : #{client[:data]}")}
        end
      end
    end
  }
}
