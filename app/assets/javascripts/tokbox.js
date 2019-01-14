    var session;
    var publisher;
    var subscribers = {};

    $(document).ready(function(){
      if(typeof(TB)=='undefined')return;
      if (TB.checkSystemRequirements() != TB.HAS_REQUIREMENTS) {
        alert("You don't have the minimum requirements to run this application."
            + "Please upgrade to the latest version of Flash.");
      } else {
        session = TB.initSession(sessionId);  // Initialize session
        session.addEventListener('sessionConnected', sessionConnectedHandler);
        session.addEventListener('sessionDisconnected', sessionDisconnectedHandler);
        session.addEventListener('connectionCreated', connectionCreatedHandler);
        session.addEventListener('connectionDestroyed', connectionDestroyedHandler);
        session.addEventListener('streamCreated', streamCreatedHandler);
        session.addEventListener('streamDestroyed', streamDestroyedHandler);
      }
    });

    function connect() {
      clearInterval(g_realtime_checker);
      $('#subscribers').show();
      session.connect(apiKey, token);
      $('#connectLink').attr('disabled',true);
    }

    function disconnect() {
      session.disconnect();
      endConnection();
      hide('disconnectLink');
      hide('publishLink');
      hide('unpublishLink');
      $('#connectLink').attr('disabled',false);
    }

    function startPublishing() {
      if (!publisher) {
        var parentDiv = document.getElementById("myCamera");
        var publisherDiv = document.createElement('div'); // Create a div for the publisher to replace
        publisherDiv.setAttribute('id', 'opentok_publisher');
        parentDiv.appendChild(publisherDiv);
        publisher = TB.initPublisher(apiKey, publisherDiv.id, {width: 220, height: 145});  // Pass the replacement div id
        session.publish(publisher);
        show('unpublishLink');
        hide('publishLink');
      }
    }

    function stopPublishing() {
      if (publisher) {
        session.unpublish(publisher);
      }
      publisher = null;
      
      

      show('publishLink');
      hide('unpublishLink');
    }

    //--------------------------------------
    //  OPENTOK EVENT HANDLERS
    //--------------------------------------

    function sessionConnectedHandler(event) {
      // Subscribe to all streams currently in the Session
      for (var i = 0; i < event.streams.length; i++) {
        addStream(event.streams[i]);
      }
      startPublishing();
      show('disconnectLink');
      show('publishLink');
      hide('connectLink');
    }

    function streamCreatedHandler(event) {
      // Subscribe to the newly created streams
      for (var i = 0; i < event.streams.length; i++) {
        addStream(event.streams[i]);
      }
    }

    function streamDestroyedHandler(event) {
      // This signals that a stream was destroyed. Any Subscribers will automatically be removed.
      // This default behaviour can be prevented using event.preventDefault()
      endConnection();
    }

    function sessionDisconnectedHandler(event) {
      // This signals that the user was disconnected from the Session. Any subscribers and publishers
      // will automatically be removed. This default behaviour can be prevented using event.preventDefault()
      publisher = null;

      
      show('connectLink');
      hide('disconnectLink');
      hide('publishLink');
      hide('unpublishLink');

    }

    function connectionDestroyedHandler(event) {
      // This signals that connections were destroyed
      endConnection();
    }

    function connectionCreatedHandler(event) {
      // This signals new connections have been created.
    }

    /*
    If you un-comment the call to TB.addEventListener("exception", exceptionHandler) above, OpenTok calls the
    exceptionHandler() method when exception events occur. You can modify this method to further process exception events.
    If you un-comment the call to TB.setLogLevel(), above, OpenTok automatically displays exception event messages.
    */
    function exceptionHandler(event) {
      alert("Exception: " + event.code + "::" + event.message);
    }

    //--------------------------------------
    //  HELPER METHODS
    //--------------------------------------

    function addStream(stream) {
      // Check if this is the stream that I am publishing, and if so do not publish.
      if (stream.connection.connectionId == session.connection.connectionId) {
        return;
      }
      $("#subscribers").append('<div id="'+stream.streamId+'"></div>');
      subscribers[stream.streamId] = session.subscribe(stream, stream.streamId, {width:640, height:480});
    }

    function show(id) {
      $('#' + id).show();
    }

    function hide(id) {
      $('#' + id).hide();
    }


    function endConnection(){
      if(is_lawyer){
        window.location.href = "/users/"+lawyer_id+"/?t=l";
      }else{
        $.ajax({
              url: "/UpdateOnlineStatus",
              type:'post',
              cache:false,
              data:'op=end_video_chat&lawyer_id='+lawyer_id+'&conversation_id='+g_conversation_id,
              success: function(response){
                 window.location.href = "/conversations/"+g_conversation_id+"/summary";
              },
              error: function(){
                //alert("An error occured while ending this conversation.");
                window.location.href = "/conversations/"+g_conversation_id+"/summary";
              }
        });
        
      }
    }






var g_invite_interval = 0;
var xhr=0;
function fn_invite_check(){
  if(typeof(fn_play_ring) == "undefined"){
    return true;
  }
  fn_play_ring();
  if(is_lawyer)return;
  $('#opentok_resume').hide();
  g_invite_interval = setInterval(function(){
    $('.spinner').hide();
    if(xhr) xhr.abort();
    xhr = $.ajax({
        url: "/UpdateOnlineStatus",
        type:'post',
        cache:false,
        data:'op=get_call_status&lawyer_id='+lawyer_id,
        success: function(response){
          switch(response){
            case "accept":
              $.ajax({
                    url: "/UpdateOnlineStatus",
                    type:'post',
                    cache:false,
                    data:'op=call&lawyer_id='+lawyer_id+'&call_mode=',
                    success: function(response){
                       
                    }
              });
              fn_cancel_lawyer();
              fn_open_video_window();
              clearInterval(g_invite_interval);
            break;
            case "decline":
              fn_cancel_lawyer();
              clearInterval(g_invite_interval);
              alert("Your invitation has been declined.");
            break;
          }
        },
        error: function(){

        }
    });
  },3000);

}

function fn_cancel_lawyer(){
  fn_stop_ring();
  $('#opentok_cancel').hide();
  $.ajax({
        url: "/UpdateOnlineStatus",
        type:'post',
        cache:false,
        data:'op=call&lawyer_id='+lawyer_id+'&call_mode=',
        success: function(response){
          if(response=="success") $('#opentok_resume').show();
        }
  });
}


function fn_accept_invite(){
  fn_stop_ring();
  $.ajax({
        url: "/UpdateOnlineStatus",
        type:'post',
        cache:false,
        data:'op=call&lawyer_id='+lawyer_id+'&call_mode=accept',
        success: function(response){
           fn_open_video_window();
        }
  });
}

function fn_decline_invite(){
  $.ajax({
        url: "/UpdateOnlineStatus",
        type:'post',
        cache:false,
        data:'op=call&lawyer_id='+lawyer_id+'&call_mode=decline',
        success: function(response){
          if(response=="success"){
            history.back();
          }
        }
  });
}


function fn_open_video_window(){
  $('#opentok_ready').remove();
  $('#video_window').show();
  connect();
}



$(function(){
  fn_invite_check();
})
