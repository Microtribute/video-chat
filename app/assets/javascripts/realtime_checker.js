var g_realtime_checker = 0;
var g_realtime_xhr = 0;
$(function(){
  if(typeof lawyer_id != 'undefined' && g_realtime_checker==0){
    g_realtime_checker=setInterval(function(){
      if(g_realtime_xhr) g_realtime_xhr.abort();
      g_realtime_xhr = $.ajax({
             url: "/UpdateOnlineStatus",
             type:'post',
             cache:false,
             data:'op=get_call_status&lawyer_id='+lawyer_id+'&call_mode=',
             success: function(response){
              if(is_lawyer && response == "invite_video_chat"){
                window.location = "/users/"+lawyer_id+"/chat_session";
              }
             }
      });
    },10000);
  }
});
