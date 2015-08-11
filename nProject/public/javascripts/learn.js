$(document).ready(function()  {
        $('#normalImage6').click(function() {
		$( "#featured" ).hide();
		$("#tryforfree").hide();
		$("#foot").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#Learn").show();
	
		$( "#tabButton" ).click(function() {
        
		$("#Learn").show();
    });
	});
		});