$(function() {
/*
	$("#products, #products a").live("click", function() {
		$.getScript(this.href);
		return false;
	});
*/
/*	
	$("#products_search input:text").keyup(function() {
		$.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
		return false;
	});
*/
	$("#friends-search-form input:text").keyup(function() {
		if ($("#friends-search-form input:text").val().length > 2) {
			$.get($("#friends-search-form").attr("action"), $("#friends-search-form").serialize(), null, "script");
		}			
		return false;
	});

	$("#friends-search-form").submit(function() {
		if ($("#friends-search-form input:text").val().length > 2) {
			$.get($("#friends-search-form").attr("action"), $("#friends-search-form").serialize(), null, "script");
		} else if	($("#friends-search-form input:text").val().length == 0) {
			$.get($("#friends-search-form").attr("action"), $("#friends-search-form").serialize(), null, "script");			
		}		
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
	
	$("#product_question_link img").click(function() {
			// Selected
			$(this).toggleClass('selected-product', true); 
			if ($(this).hasClass('selected-product')) {
				$(this).parents('li').removeClass('not-selected-product');
				$(this).parents('li').siblings().removeClass('selected-product');
				$(this).parents('li').siblings().addClass('not-selected-product');
				$('#question_product_id').attr('value', $(this).attr("id"))
				$('#my_collection_item_id').attr('value', $(this).parents('li').attr("id"))
			} else {
				$(this).parents('li').addClass('not-selected-product');			
				//$(this).find('.product_id').attr('value', '')
			}
	});

/*
  $.fn.extend({
		modalPanel: function() {

        //Create our overlay object
        var overlay = $("<div id='modal-overlay'></div>");
				var modalWindow = $("<div id='modal-window'></div>");
        return this.each(function() {

            //Listen for clicks on objects passed to the plugin
            $(this).click(function(e) {
                //Append the overlay to the document body
                $("body").append(overlay.click(function() { 
                    modalHide(); 
                }))

                //Set the css and fade in our overlay
                overlay.css("opacity", 0.8);
                overlay.fadeIn(150);

                //Prevent the anchor link from loading
                e.preventDefault();

                //Activate a listener 
                $(document).keydown(handleEscape);		
            });
        });

        //Our function for hiding the modalbox
        function modalHide() {
				    $(document).unbind("keydown", handleEscape)
				    var remove = function() { $(this).remove(); };
				    overlay.fadeOut(remove);
				    modalWindow.fadeOut(remove).empty();
        }

        //Our function that listens for escape key.
        function handleEscape(e) {
            if (e.keyCode == 27) {
                modalHide();
            }
        }
    }
	});
	
	$('a[rel*=modalPanel]').modalPanel();	
*/	
});