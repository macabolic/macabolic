$(function() {
/*
	$("#products, #products a").live("click", function() {
		$.getScript(this.href);
		return false;
	});
*/	
	$("#products_search input:text").keyup(function() {
		$.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
		return false;
	});

	$("#recommend_link img").click(function() {
		if (this.getAttribute('class') == 'noborderimage') {
			// Selected
			this.setAttribute('class', 'borderedimage')
			//var value = $('#number_of_recommendation').val();
			//value++;
			//$('#number_of_recommendation').val(value);
		} else {
			// De-selected
			this.setAttribute('class', 'noborderimage')			
			//var value = $('#number_of_recommendation').val();
			//value--;
			//$('#number_of_recommendation').val(value);
		}		
		return false;
	});
	
	$("#make_recommendation").submit(function() {
		var count = 0;
		var users = new Array();		
		$("#search-friend-list li").each(function(index) {
			if ($("img", this).attr("class") == "borderedimage") {
				user_id = $("img", this).attr("id");
				users[count] = user_id
				count++;
			}
		});

		if (count > 0) {
			$('#to_user_id').val(users);				
		}

		$("#friends").html("");
		return true;
	});
});