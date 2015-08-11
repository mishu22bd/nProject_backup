$(document).ready(function()  {
        $('#normalImage1').click(function() {
		$( "#featured" ).hide();
		$("#tryforfree").hide();
		$("#foot").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#attendMeeting").show();
	
		$( "#tabButton" ).click(function() {
        
		$("#attendMeeting").show();
    });
	});
		});

		
//$(document).ready(function(){
  //$(document).ajaxStart(function(){
    //$("#wait").css("display","block").delay(5000);
  //});
  //$(document).ajaxComplete(function(){
    //$("#wait").css("display","none").delay(5000);
  //});
  //$("button").click(function(){
    //$("#frame1").load("attend.php");
  //});
//});
