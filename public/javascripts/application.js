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
	$('#wishlist_link_1 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_1").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_2 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_2").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_3 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_3").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_4 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_4").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_5 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_5").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_6 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_6").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_7 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_7").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_8 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_8").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_9 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_9").replaceWith("<b>Added</b>");
		return false;
	});
	$('#wishlist_link_10 a').live('click', function() {
		$.getScript(this.href);
		$("#add_wishlist_item_link_10").replaceWith("<b>Added</b>");
		return false;
	});
	
});