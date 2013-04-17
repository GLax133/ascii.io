
(function() {

  $(function() {
    var liveterm = $("#liveterm1");
    var name, url, ws;
    name = $('#divroom').data('username');
    $("#message").focus();
    
    
    liveterm = new Terminal(80, 24);
    if (liveterm)
    	liveterm.open("liveterm1");

    url = "ws://127.0.0.1:8088";
    ws = new WebSocket(url);
    ws.open;
    $("#message_form").submit(function(event) {
      var message, roomid;
      message = $("#message");
      roomid = $('#divroom').data('roomname');
      roomid = "room" + roomid;
      ws.send(JSON.stringify({
        id: name,
        action: "say",
        data: message.val(),
        room: roomid
      }));
      message.val('');
      message.focus();
      return event.preventDefault();
    });
    $("#message").bind('keyup',function(event){
	if (event.keyCode == '13'){
	      var message, roomid;
      		message = $("#message");
      		roomid = $('#divroom').data('roomname');
      		roomid = "room" + roomid;
      	ws.send(JSON.stringify({
        	id: name,
        	action: "say",
        	data: message.val(),
        	room: roomid
         }));
      		message.val('');
      		message.focus();
      		return event.preventDefault();

	}
    });
    ws.onopen = function() {
      var roomid;
      roomid = $('#divroom').data('roomname');
      roomid = "room" + roomid;
      return ws.send(JSON.stringify({
        id: name,
        action: "connect",
        room: roomid
      }));
    };
    ws.onmessage = function(message) {
      var line, msgs, now_hm, now_time;
      msgs = message.data.split(":");
      if (message.data.substring(0,7) != 'teacher') {
        now_time = new Date();
        now_hm = now_time.getHours() + ':' + now_time.getMinutes();
        line = '<div class="chat chat-1111 rounded"><span class="gravatar"><img src="' + '" width="23" height="23" onload="this.style.visibility=\'visible\'" /></span><span class="author">' + msgs[0] + ':</span><span class="text">' + msgs[1] + '</span><span class="time">' + now_hm + '</span></div>';
        $(".chatLineHolder").append(line);
        $("#chatLineHolder").scrollTop = $("#chatLineHolder").scrollHeight;
      } else {
	var s= message.data.substr(10);
        liveterm.write(s);
      }
    };
    ws.onclose = function() {
      var roomid;
      roomid = $('#divroom').data('roomname');
      roomid = "room" + roomid;
      return ws.send(JSON.stringify({
        id: name,
        room: roomid
      }));
    };
    return $("#save_chat_log").submit(function(event) {
      $.post(this.action, {
        chat_data: $("#chat_window").html().replace(/<br>/g, "\n")
      }, function(data) {
        var log_link;
        log_link = $("#log_link");
        log_link.attr('href', data);
        return log_link.show();
      });
      return event.preventDefault();
    });
  });

}).call(this);

