
 
$(document).ready(function()  {
        $("#normalImage4").click(function() {
		$( "#featured" ).hide();
		$("#foot").hide();
		//$("#footer").hide();
		
		$( "#tabButton" ).menu();
        $('.allTabs').slideToggle(1000);
		$("#myCal").show();
	
	
		});
		});
	
	$(function(){

    var $header = $('#header');
    var $footer = $('#footer');
    var $content = $('#content');
    var $window = $(window).on('resize', function(){
       var height = $(this).height() - $header.height() + $footer.height();
       $content.height(height);
    }).trigger('resize'); //on page load

});$(function(){

    var $header = $('#header');
    var $footer = $('#footer');
    var $content = $('#content');
    var $window = $(window).on('resize', function(){
       var height = $(this).height() - $header.height() + $footer.height();
       $content.height(height);
    }).trigger('resize'); //on page load

});
	
	


  


	