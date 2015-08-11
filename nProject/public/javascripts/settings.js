$(document).ready(function()  {
        $('#normalImage5').click(function() {
		$( "#featured" ).hide();
		$("#tryforfree").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#mySet").show();
	
    });
	});