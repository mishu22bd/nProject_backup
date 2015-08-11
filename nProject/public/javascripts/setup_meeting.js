$(document).ready(function()  {
        $('#normalImage2').click(function() {
		$( "#featured" ).hide();
		$("#tryforfree").hide();
		$("#foot").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#setupMeeting").show();
	
		$( "#tabButton" ).click(function() {
        
		$("#setupMeeting").show();
    });
	});
		});
