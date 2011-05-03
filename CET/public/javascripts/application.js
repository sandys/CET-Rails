// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {

  $("#batch_date").datepicker();
  $("#sales_txndate").datepicker();
  $("#batch_location").change(function() {
    var id = $('#batch_location').val();
    $.post('sales_type', {location_id : id }, function(data) {
      $("#sales_type").html(data);
    });
  });
  
  $("#sales_type").change(function() {
    var id = $('#sales_type').val();
    $.post('sales_txn_type', {sales_type_id : id }, function(data) {
      $("#sales_txntype").html(data);
    });
  });
  
  
})
