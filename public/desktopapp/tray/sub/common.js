var g_server_url = "https://www.lawdingo.com";
//var g_server_url = "http://192.168.1.141:3000";
var g_email = '';
var g_password = '';
var g_interval = 0;
var g_waiting_from_xhr = 0;
var g_is_online = false;
var gPendingInterval = 0;
var g_once = false;

$(function(){
	var _preventDefault = function(evt) { evt.preventDefault(); };
	$("*:not(input)").bind("dragstart", _preventDefault).bind("selectstart", _preventDefault);

	gPendingInterval = setInterval(function(){
		if($('#btnShowApp').val()=='Done'){
			clearInterval(gPendingInterval);
			fn_open_loginWindow();
			return;
		}
		//alert('here')
		$('#btnShowApp').trigger('click');
	},1000);
});


function fn_open_loginWindow(){
	$('#loginWindow').dialog({
		bgiframe: true,
		modal: true,
		resizable:false,
		draggable:false,
		close:function(){
			$('.ui-dialog').remove();
			fn_open_unlogged_screen();
		}
	});
	$('#useremail').focus();
}


function fn_cancel_login(){
	$("#loginWindow").dialog('close');
}

function fn_open_unlogged_screen(){
	$("#unloggedScreen").dialog({
		bgiframe: true,
		modal: true,
		resizable:false,
		draggable:false,
		title:false,
		close:function(){
			$('.ui-dialog').remove();
		}
	});
}

function fn_open_loginWindow_from_unloggedScreen(){
	$("#unloggedScreen").dialog('close');
	fn_open_loginWindow();
}


function fn_login(){
	var email = $('#useremail').val();
	var password = $('#password').val();
	if(email=='' || password==''){
		alert("Please enter the vaild information.");
		return;
	}
	g_email = email;
	g_password = password;
	$('#btnLogin').attr('disabled',true);
	$.ajax({
		url : g_server_url+"/UpdateOnlineStatus",
		type:'post',
		dataType:"json",
		data:'op=login_by_app&email='+email+'&password='+password,
		cache:false,
		success:function(msg){
			$('#btnLogin').attr('disabled',false);
			fn_login_callback(msg);
		},error:function(msg){
			g_email = g_password = '';
			$('#btnLogin').attr('disabled',false);
			alert("An error occured while logging in.");
		}
	});
}

function fn_login_callback(login){
	if(login.result==null){
		g_email = g_password = '';
		alert("An error occured while logging in.");
		return;
	}else{
		fn_open_setting_window();
	}
}


function fn_open_setting_window(){
	$('#settingWindow').dialog({
		bgiframe: true,
		modal: true,
		resizable:false,
		draggable:false,
		close:function(){
			$('.ui-dialog').remove();
		}
	});
	$('#rdoAppear').attr('checked',true);
}


function fn_apply_setting(){
	$('#btnApply').attr('disabled',true);
	var is_online = $('#rdoAppear').attr('checked').toString();
	$.ajax({
		url : g_server_url+"/UpdateOnlineStatus",
		type:'post',
		dataType:"json",
		data:'op=set_status_by_app&email='+g_email+'&password='+g_password+'&is_online='+is_online,
		cache:false,
		success:function(msg){
			$('#btnApply').attr('disabled',false);
			fn_appsaving_callback(msg);
		},error:function(msg){
			$('#btnApply').attr('disabled',false);
			alert("An error occured while saving the values.\nPlease try again.");
		}
	});
}

function fn_appsaving_callback(msg){
	if(msg.result){
		//alert("Saved successfully!");
		fn_start_realchecking();
		return;
	}else{
		alert("An error occured while saving the values.\nPlease try again.");
	}
}

function fn_logout(){
	location.reload();
}


function fn_start_realchecking(){
	(g_interval!=0 && clearInterval(g_interval));
	g_is_online = true;
	g_interval = setInterval(fn_real_check,3000);
}

function fn_real_check(){
	if(!g_is_online)return;
	if(g_waiting_from_xhr)return;
	g_waiting_from_xhr = true;
	$.ajax({
		url : g_server_url+"/UpdateOnlineStatus",
		type:'post',
		dataType:"json",
		data:'op=login_by_app&email='+g_email+'&password='+g_password,
		cache:false,
		success:function(msg){
			g_waiting_from_xhr = false;
			fn_real_check_callback(msg);
		},error:function(msg){
			g_waiting_from_xhr = false;
		}
	});
}

function fn_real_check_callback(msg){
	if(msg.result && msg.result.call_status!=""){
		fn_process_call_status(msg.result.call_status);
	}
}

function fn_process_call_status(call_status){
	switch(call_status){
		case "invite_video_chat":
			if(g_once){
				
			}else{
				$('#btnPopup').trigger('click');
				fn_open_accept_window();
			}
		break;
		case "accept":
			$("#acceptWindow").dialog('close');
			$('#btnAccept').attr('disabled',false);
			g_once = false;
		break;
	}
}


function fn_open_accept_window(){
	fn_play_ring();
	$('#acceptWindow').dialog({
		bgiframe: true,
		modal: true,
		resizable:false,
		draggable:false,
		close:function(){
			$('.ui-dialog').remove();
			fn_open_setting_window();
		}
	});
}

function fn_accept_call(){
	$('#btnAccept').attr('disabled',true);
	$('#myForm input[name=email]').val(g_email);
	$('#myForm input[name=password]').val(g_password);


	g_once = true;
	$("#acceptWindow").dialog('close');
	fn_stop_ring();

	$('#myForm').get(0).submit();
	return;
	
}



function fn_accept_callback(msg){
	if(msg.result){
		//$("#acceptWindow").dialog('close');
		$('#myForm').get(0).submit();
	}else{
		alert("An error occured while saving the values.\nPlease close this window and try again.");
	}
}




function fn_decline_call(){
	$('#btnDecline').attr('disabled',true);
	fn_stop_ring();
	$.ajax({
		url : g_server_url+"/UpdateOnlineStatus",
		type:'post',
		dataType:"json",
		data:'op=set_status_by_app&email='+g_email+'&password='+g_password+'&call_status=decline',
		cache:false,
		success:function(msg){
			fn_decline_callback(msg);
			$('#btnDecline').attr('disabled',false);
		},error:function(msg){
			alert("An error occured while saving the values.\nPlease close this window and try again.");
			$('#btnDecline').attr('disabled',false);
		}
	});

}

function fn_decline_callback(msg){
	if(msg.result){
		$("#acceptWindow").dialog('close');
		
	}else{
		alert("An error occured while saving the values.\nPlease close this window and try again.");
	}
}


