function purchase_order_index_init_listeners() {

  $('#po_status').change(purchase_order_index_ajax);
  $('#po_supplier').change(purchase_order_index_ajax);

  $('#purchase_orders tr').on('click', function(){
    $('#purchase_orders tr').removeClass('highlight');
    $(this).addClass('highlight');
    purchase_order_show_ajax($(this).attr('id'));
  });

}

function purchase_order_index_ajax() {
    status = $('#po_status').val();
    supplier_id = $('#po_supplier').val();
    $.ajax({
      dataType: 'script',
      url: "/purchase_orders?status=" + status +"&supplier_id=" + supplier_id
    });
}

function purchase_order_show_ajax(id) {
    $.ajax({
      dataType: 'script',
      url: "/purchase_orders/" + id
    });
}

