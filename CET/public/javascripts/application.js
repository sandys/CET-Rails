// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {

  $("#batch_date").datepicker();
  $("#sales_txn_date").datepicker();
    $("#sales_date").datepicker();
    
  $("#batch_location").change(function() {
    var id = $('#batch_location').val();
    $.post('sales_type', {location_id : id }, function(data) {
      $("#sales_type").html(data);
    });
  });
  
  $("#sales_type").change(function() {
    var id = $('#sales_type').val();
    $.post('sales_txn_type', {sales_type_id : id }, function(data) {
      $("#sales_txn_type").html(data);
    });
    
    $.post('sales_counselor', {sales_type_id : id }, function(data) {
      $("#sales_primary_counselor").html(data);
      $("#sales_secondary_counselor_1").html(data);
      $("#sales_secondary_counselor_2").html(data);
      $("#sales_secondary_counselor_3").html(data);
    });
  });
  
  $("#sales_txn_type").change(function() {
    var id = $('#sales_txn_type').val();
    $.post('sales_lead_source', {sales_txn_type_id : id }, function(data) {
      $("#sales_lead_source").html(data);
    });
  });
  
  
  
})
