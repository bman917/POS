//Validates if the autocomplete form is properly pouplated
function validate_item_autocomplete(item_id_css,item_price_css) {
	ret_val = true;
	if ($(item_id_css).val().length    === 0 || 
		$(item_price_css).val().length === 0) 
	{
		ret_val = false;
	}
	// console.log("validate_item_autocomplete = " + ret_val);
	return ret_val;
}