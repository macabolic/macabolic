$(function() {
	$('#products th a, #products .pagination a').live('click', function() {
		$.getScript(this.href);
		return false;
	});
	$('#products_search input').keyup(function() {
		$.get($("#products_search").attr("action"), $("#products_search").serialize(), null, "script");
		return false;
	});
	$('#wishlist_link a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link").replaceWith("<b>Added</b>");
		return false;
	});
});