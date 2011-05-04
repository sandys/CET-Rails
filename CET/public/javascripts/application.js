// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {

  $("#contract_sales_batch_date").datepicker();
  $("#contract_sales_txn_date").datepicker();
  $("#contract_sales_date").datepicker();
  $(".down_payment_date").datepicker();
  $("#contract_interest_payment_start_date").datepicker();
    
  $("#contract_location_id").change(function() {
    var id = $("#contract_location_id").val();
    $.post('sales_type', {location_id : id }, function(data) {
      $("#contract_sales_type").html(data);
    });
    
    $.post('item_group_code', {location_id : id }, function(data) {
      $(".item_group_code").html(data);
    });

  });
  
  $("#contract_sales_type").change(function() {
    var id = $("#contract_sales_type").val();
    $.post('sales_txn_type', {sales_type_id : id }, function(data) {
      $("#contract_sales_txn_type").html(data);
    });
    
    $.post('sales_counselor', {sales_type_id : id }, function(data) {
      $("#contract_sales_primary_counselor").html(data);
      $("#contract_sales_secondary_counselor_1").html(data);
      $("#contract_sales_secondary_counselor_2").html(data);
      $("#contract_sales_secondary_counselor_3").html(data);
    });
    
    $.post('payment_type', {sales_type_id : id }, function(data) {
      $(".down_payment_type").html(data);
    });
    
     $.post('interest_term', {sales_type_id : id }, function(data) {
      $("#contract_interest_term").html(data);
    });
    
     $.post('interest_method', {sales_type_id : id }, function(data) {
      $("#contract_interest_method").html(data);
    });
    
  });
  
  $("#contract_sales_txn_type").change(function() {
    var id = $("#contract_sales_txn_type").val();
    $.post('sales_lead_source', {sales_txn_type_id : id }, function(data) {
      $("#contract_sales_lead_source").html(data);
    });
  });
  
  $(".item_group_code").change(function() {
    var id = this.id.match(/\d+/)[0];
    $.post('item_category_code', {group_code_id : id }, function(data) {
      $("#contract_item_"+id+"_category_code").html(data);
    });
  })
})
