



$(document).ready(function(){  


		 $('#btnReg').on('click',function(e){

        e.preventDefault();
		
					 

               

  
             $.post( "setup_form.php", $("#setupAcc").serializeArray(),function(){
                 $('#status').css({'display':'block'}).delay(500).fadeOut(); 
            $('#preloader').css({'display':'block'}).delay(500).fadeOut('slow');
			
			


             } );
			 
			 


            


    }); 
});
