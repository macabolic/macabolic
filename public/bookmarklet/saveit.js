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
		initBookmarklet();
	}

	function initBookmarklet() {
		(window.myBookmarklet = function() {
			function highlightImages() {
				var ilist = document.images;
				$("body").append("\
				<style type='text/css'>\
					.macabolic_highlighted_product { border: 5px solid red; }\
				</style>\
				");
				for(var i = 0; i < ilist.length; i++) {
					$(ilist[i]).toggleClass('macabolic_highlighted_product');
					$(ilist[i]).click(function(event) {
						url = this.src
						loadWindow(i, url);
						return false;
					});					
				}
			}

			function loadWindow(i, url) {
				$("body").append("\
				<div id='macabolicicon'></div>\
				<div id='macabolicframe'>\
					<div id='macabolicframe_veil' style=''>\
						<div id='macabolicicon'></div>\
						<p>Loading...</p>\
					</div>\
					<iframe src='http://macbook-pro.local:3001/bookmarklets/new?type=product&image_url="+url+"&locale=en' onload=\"$('#macabolicframe iframe').slideDown(500);\">Enable iFrames.</iframe>\
					<style type='text/css'>\
						#macabolicicon { display: none: position: fixed; width: 90px; height: 110px; top: 20%; right: 0; background-color: rgba(0,0,0,0.5); cursor: pointer; z-index: 999; background-image: url(../images/logo-icon-only.png); margin-top: 57px; margin-left: 10px;}\
						#macabolicframe_veil { display: none; position: fixed; width: 100%; height: 100%; top: 0; left: 0; background-color: rgba(255,255,255,.25); cursor: pointer; z-index: 900; }\
						#macabolicframe_veil p { color: black; font: normal normal bold 20px/20px Helvetica, sans-serif; position: absolute; top: 50%; left: 50%; width: 10em; margin: -10px auto 0 -5em; text-align: center; }\
						#macabolicframe iframe { display: none; position: fixed; top: 10%; left: 10%; width: 80%; height: 80%; z-index: 999; border: 10px solid rgba(0,0,0,.5); margin: -5px 0 0 -5px; }\
					</style>\
				</div>");
				$("#macabolicframe_veil").fadeIn(750);				
				//$("#draggable_iframe").draggable();
				$("#macabolicicon").click(function(event){
					$("#macabolicicon").fadeOut(750);				
					$("#macabolicframe_veil").fadeOut(750);
					$("#macabolicframe iframe").slideUp(500);
					setTimeout("$('#macabolicframe').remove()", 750);
				});				

				$("#macabolicframe_veil").click(function(event){
					$("#macabolicicon").fadeOut(750);				
					$("#macabolicframe_veil").fadeOut(750);
					$("#macabolicframe iframe").slideUp(500);
					setTimeout("$('#macabolicframe').remove()", 750);
					//$(document.images[i]).unbind('click');
				});				
			}
			highlightImages();
			
		})();
	}

})();