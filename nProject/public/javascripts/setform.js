 $(document).ready(function(){
    $( '#setup' ).click(function() {
    	location.href='http://localhost:9000/account/register';


//        $( "#setupAcc" ).dialog( "open" );
      });      
	  
	  $( "#setupAcc" ).dialog({
      autoOpen: false,
      height: $(window).height() - 110,
      width: $(window).width() - 600,
      modal: true,
	 
	  
	  
	  });
	  
});  