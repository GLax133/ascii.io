
(function() {

  $(function() {
    var liveterm = $("#liveterm1");
    var name, url, ws;
    name = $('#divroom').data('username');
    $("#message").focus();
    
    
    liveterm = new Terminal(80, 24);
    liveterm.open("liveterm1");

    url = "ws://127.0.0.1:8080";
    ws = new WebSocket(url);
    ws.open;
    $("#message_form").submit(function(event) {
      var message, roomid;
      message = $("#message1");
      if (message.val() == '')
      		return event.preventDefault();
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
    $("#message1").bind('keyup',function(event){
	if (event.keyCode == '13'){
		var message, roomid;
      		message = $("#message1");
                if (message.val() == '')
      			return event.preventDefault();
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
      var line, now_hm, now_time,name,content;
      var msgs = JSON.parse(message.data);
      console.log(msgs);
      console.log(msgs.action);
      console.log(msgs.data);
      if (msgs.action == 'teacher')
      {
	liveterm.write(msgs.data);
      }
      if (msgs.action == 'say')
      {
	 name = msgs.id;	
	 content = msgs.data;	
     
        now_time = new Date();
        now_hm = now_time.getHours() + ':' + now_time.getMinutes();
        line = '<div class="chat chat-1111 rounded"><span class="gravatar"><img src="' + '" width="23" height="23" onload="this.style.visibility=\'visible\'" /></span><span class="author">' + name + ':</span><span class="text">' + content + '</span><span class="time">' + now_hm + '</span></div>';
        $(".chatLineHolder").append(line);
        document.getElementById("chatLineHolder").scrollTop = document.getElementById('chatLineHolder').scrollHeight;
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

