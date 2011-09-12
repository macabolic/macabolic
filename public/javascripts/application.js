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
});