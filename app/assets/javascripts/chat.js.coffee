$ ->
  #name = prompt("What is your name?")
  #$("#name").text(name)
  $("#message").focus()

  #websocket stuff
  url = "ws://www.codepark.us:8088"
  ws = new WebSocket(url)   
  ws.open
  
  $("#message_form").submit (event) ->
    message = $("#message")
    room = $("#room")
    ws.send(JSON.stringify({id: name, action: "say", data : message.val(),room:room.val(),}))
    message.val('')
    message.focus();
    event.preventDefault()
  
  ws.onopen = ->
    room = $("#room")
    ws.send(JSON.stringify({id: name, action: "connect",room:room.val()}))
    
  ws.onmessage = (message) ->
    msgs = message.data.split(":")
    now_time = new Date()
    now_hm  = now_time.getHours() + ':' + now_time.getMinutes()
    line =  '<div class="chat chat-1111 rounded"><span class="gravatar"><img src="'+'" width="23" height="23" onload="this.style.visibility=\'visible\'" /></span><span class="author">' + msgs[0]+':</span><span class="text">'+msgs[1]+'</span><span class="time">'+now_hm+'</span></div>'

    $(".chatLineHolder").append(line)
    $("#chatLineHolder").scrollTop = $("#chatLineHolder").scrollHeight 
    
  ws.onclose = ->
    room = $("#room")
    ws.send(JSON.stringify({id: name, room:room.val()}))
    #onclose not firing for some reason

  #save chat log
  $("#save_chat_log").submit (event) ->
    $.post this.action, {chat_data : $("#chat_window").html().replace(/<br>/g, "\n")}, (data) ->
      log_link = $("#log_link")
      log_link.attr('href', data)
      log_link.show()
    event.preventDefault()
