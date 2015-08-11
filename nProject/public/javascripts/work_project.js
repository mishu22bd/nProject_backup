$(document).ready(function()  {
        $('#normalImage3').click(function() {
		$( "#featured" ).hide();
		$("#tryforfree").hide();
		$("#foot").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#workProject").show();
	

    });
    });