//Validates if the autocomplete form is properly pouplated
function validate_item_autocomplete(item_id_css,item_qty_css,item_price_css) {
	ret_val = true;
	console.log("item_id_css length: "    + $(item_id_css).val().length);
	console.log("item_qty_css length: " + $(item_qty_css).val().length);
	console.log("item_price_css length: " + $(item_price_css).val().length);

	if ($(item_id_css).val().length    === 0 ||
	    $(item_qty_css).val().length   === 0 ||
		$(item_price_css).val().length === 0) 
	{
		ret_val = false;
	}

	if (isNaN($(item_qty_css).val()) ||
		$(item_qty_css).val() < 1) {
		ret_val = false;
	}

	console.log("validate_item_autocomplete = " + ret_val);
	return ret_val;
}