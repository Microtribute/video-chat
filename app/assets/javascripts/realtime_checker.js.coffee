g_realtime_checker = g_realtime_xhr = 0;
jQuery ->
  if g_realtime_checker==0
    g_realtime_checker = setInterval(() -> 
        g_realtime_xhr.abort() if typeof lawyer_id != 'undefined' &&  g_realtime_xhr 

        g_realtime_xhr = $.ajax
          url: "/UpdateOnlineStatus",
          type:'post',
          cache:false,
          data:'op=get_call_status&lawyer_id='+lawyer_id+'&call_mode=',
          success: (response) ->
              window.location = "/users/"+lawyer_id+"/chat_session" if is_lawyer && response == "invite_video_chat"

      10000
    )  
