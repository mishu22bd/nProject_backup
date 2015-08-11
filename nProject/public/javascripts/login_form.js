
$(document).ready(function(){  


		 $('#loginbtn').on('click',function(e){

        e.preventDefault();
		
	
  
             $.post( "login.php", $("#login_form").serializeArray(),function(){
                 $('#status').css({'display':'block'}).delay(500).fadeOut(); 
            $('#preloader').css({'display':'block'}).delay(500).fadeOut('slow');
			
			


             } );
			 
			 


            


    }); 
});