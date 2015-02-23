function purchase_order_index_init_listeners() {

  $('#po_status').change(purchase_order_index_ajax);
  $('#po_supplier').change(purchase_order_index_ajax);
  purchase_order_table_click_listener();
  purchase_order_create_listener();
}

function purchase_order_index_ajax() {
    overlay();
    status = $('#po_status').val();
    supplier_id = $('#po_supplier').val();
    $.ajax({
      dataType: 'script',
      url: "/purchase_orders?status=" + status +"&supplier_id=" + supplier_id
    });
}

/*
 *Used by purchase_orders/_table.html.erb. Adds a listner so that when a
 *table row is clicked. An ajax call we be made to display the PO details.
 */
function purchase_order_table_click_listener() {
  $('#purchase_orders tbody tr td.click').on('click', function(){
    overlay();
    $('#purchase_orders tbody tr td a').hide();
    $('#purchase_orders tbody tr').removeClass('highlight');
    var current_row = $(this).closest('tr');
    current_row.find('a').show();
    current_row.addClass('highlight');
    purchase_order_show_ajax(current_row.attr('data-id'));
  });
}

function purchase_order_show_ajax(id) {
    $.ajax({
      dataType: 'script',
      url: "/purchase_orders/" + id,
      complete: remove_overlay
    });
}

function purchase_order_show_notification(message) {
  $('#show_details_notifications').append(message);
  $('#show_details_notifications').toggle();
  $(document).foundation('alert', 'reflow');
}

function purchase_order_create_listener() {

  $('a#new_purchase_order').on('click', function() {

    supplier_id = $('#po_supplier').val();
    supplier = $('#po_supplier option:selected').text();

    if (confirm("New Purchase Order for '" + supplier + "'?")) {
      $.ajax({
        dataType: 'script',
        url: "/purchase_orders/new?supplier_id=" + supplier_id      
      });
    }
    return false;
  });

}

function purchase_order_show_check_box_listener() {
  var checkbox_selector = '#purchase_order_show_details input[type="checkbox"]';

  $(checkbox_selector).unbind();
  $(checkbox_selector).change(function(event) {
    if ($(checkbox_selector + ":checked").length > 0) {
      $('#delete_item_purchase_order_button').removeAttr('disabled');
    } else {
      $('#delete_item_purchase_order_button').attr('disabled', 'disabled');
    }
  });
}

function purchase_order_show_keyboard_shortcuts() {
  Mousetrap.bind('alt+a', function(e){
    $('#po_detail_add_item_button').click();
  });
}