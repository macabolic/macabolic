(function(){

	var v = "1.3.2";

	if (window.jQuery === undefined || window.jQuery.fn.jquery < v) {
		var done = false;
		var script = document.createElement("script");
		script.src = "http://ajax.googleapis.com/ajax/libs/jquery/" + v + "/jquery.min.js";
		script.onload = script.onreadystatechange = function(){
			if (!done && (!this.readyState || this.readyState == "loaded" || this.readyState == "complete")) {
				done = true;
				initAnotherBookmarklet();
			}
		};
		document.getElementsByTagName("head")[0].appendChild(script);
	} else {
		//initMyBookmarklet();
		initAnotherBookmarklet();
	}

	function initMyBookmarklet() {
		(window.myBookmarklet = function() {
			function getSelText() {
				var s = '';
				if (window.getSelection) {
					s = window.getSelection();
				} else if (document.getSelection) {
					s = document.getSelection();
				} else if (document.selection) {
					s = document.selection.createRange().text;
				}
				return s;
			}
			if ($("#wikiframe").length == 0) {
				var s = "";
				s = getSelText();
				if (s == "") {
					var s = prompt("Forget something?");
				}
				if ((s != "") && (s != null)) {
					$("body").append("\
					<div id='wikiframe'>\
						<div id='wikiframe_veil' style=''>\
							<p>Loading...</p>\
						</div>\
						<iframe src='http://en.wikipedia.org/w/index.php?&search="+s+"' onload=\"$('#wikiframe iframe').slideDown(500);\">Enable iFrames.</iframe>\
						<style type='text/css'>\
							#wikiframe_veil { display: none; position: fixed; width: 100%; height: 100%; top: 0; left: 0; background-color: rgba(255,255,255,.25); cursor: pointer; z-index: 900; }\
							#wikiframe_veil p { color: black; font: normal normal bold 20px/20px Helvetica, sans-serif; position: absolute; top: 50%; left: 50%; width: 10em; margin: -10px auto 0 -5em; text-align: center; }\
							#wikiframe iframe { display: none; position: fixed; top: 10%; left: 10%; width: 80%; height: 80%; z-index: 999; border: 10px solid rgba(0,0,0,.5); margin: -5px 0 0 -5px; }\
						</style>\
					</div>");
					$("#wikiframe_veil").fadeIn(750);
				}
			} else {
				$("#wikiframe_veil").fadeOut(750);
				$("#wikiframe iframe").slideUp(500);
				setTimeout("$('#wikiframe').remove()", 750);
			}
			$("#wikiframe_veil").click(function(event){
				$("#wikiframe_veil").fadeOut(750);
				$("#wikiframe iframe").slideUp(500);
				setTimeout("$('#wikiframe').remove()", 750);
			});
		})();
	}		

	function initAnotherBookmarklet() {
		(window.myBookmarklet = function() {
			function highlightImages() {
				//alert("In the highlightImages method.");
				var ilist = document.images;
				$("body").append("\
				<style type='text/css'>\
					.macabolic_highlighted_product { border: 3px solid red; }\
				</style>\
				");
				for(var i = 0; i < ilist.length; i++) {
					$(ilist[i]).toggleClass('macabolic_highlighted_product');
					$(ilist[i]).click(function(event) {
						//alert("You have clicked the image with url: " + $(this).attr('src'));
						url = $(this).attr('src');
						loadWindow(url);
						return false;
					});					
				}
			}

			function loadWindow(url) {
				$("body").append("\
				<div id='macabolicframe'>\
					<div id='macabolicframe_veil' style=''>\
						<p>Loading...</p>\
					</div>\
					<iframe src='http://macbook-pro.local:3001/bookmarklets/new?type=product&image_url="+url+"&locale=en' onload=\"$('#macabolicframe iframe').slideDown(500);\">Enable iFrames.</iframe>\
					<style type='text/css'>\
						#macabolicframe_veil { display: none; position: fixed; width: 100%; height: 100%; top: 0; left: 0; background-color: rgba(255,255,255,.25); cursor: pointer; z-index: 900; }\
						#macabolicframe_veil p { color: black; font: normal normal bold 20px/20px Helvetica, sans-serif; position: absolute; top: 50%; left: 50%; width: 10em; margin: -10px auto 0 -5em; text-align: center; }\
						#macabolicframe iframe { display: none; position: fixed; top: 10%; left: 10%; width: 80%; height: 80%; z-index: 999; border: 10px solid rgba(0,0,0,.5); margin: -5px 0 0 -5px; }\
					</style>\
				</div>");
				$("#macabolicframe_veil").fadeIn(750);				
				$("#macabolicframe_veil").click(function(event){
					$("#macabolicframe_veil").fadeOut(750);
					$("#macabolicframe iframe").slideUp(500);
					setTimeout("$('#macabolicframe').remove()", 750);
				});				
			}
			highlightImages();
			
		})();
	}

})();