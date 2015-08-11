function remove_fields (link){
	$(link).previous("input[type=hidden]").value=1;
	$(link)up(".field").hide();
}