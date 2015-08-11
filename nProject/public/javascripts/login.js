


 $(document).ready(function(){
    $( '#login' ).click(function() {
      location.href='http://localhost:9000';
//        $( "#login_form" ).dialog( "open" );
      });      
	  
	  $( "#login_form" ).dialog({
      autoOpen: false,
	  height: $(window).height() - 350,
      width: $(window).width() - 800,
      modal: true,
	  open: function (event, ui) {
    $('#dialog-form').css('scroll', 'none'); 
  }
	  
	  });
});
    
	
