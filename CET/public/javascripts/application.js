// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {

  $("#contract_sales_batch_date").datepicker();
  $("#contract_sales_txn_date").datepicker();
  $("#contract_sales_date").datepicker();
  $(".down_payment_date").datepicker();
  $("#contract_interest_payment_start_date").datepicker();
  
  $("#contract_username").focus(function() {
    $.post('/contracts/usernames', {}, function(data) {
     $("#contract_username").autocomplete({source: data});
    });
  });
  
  $("#contract_username").blur(function() {
    var id = $(this).val();
    $.post('/contracts/user_password', {user_id : id }, function(data) {
      $("#contract_password").val(data);
    });
    
    $.post('/contracts/user_location', {user_id : id }, function(data) {
     // $("#contract_location_id").html(data);
     $("#contract_location_id").autocomplete({source: data});
    });
  });
  
  
  $("#contract_location_id").focus(function() {
    $.post('/contracts/user_location', {user_id : $('#contract_username').val() }, function(data) {
     $("#contract_location_id").autocomplete({source: data});
    });
  });
  
  $("#contract_location_id").blur(function() {
    var id = $("#contract_location_id").val();
    $.post('/contracts/sales_type', {location_id : id }, function(data) {
      //$("#contract_sales_type").html(data);
      $("#contract_sales_type").autocomplete({source: data});
    });
    
    $.post('/contracts/item_group_code', {location_id : id }, function(data) {
      $(".item_group_code").autocomplete({source: data}); //$(".item_group_code").html(data);
    });

  });
  
  $("#contract_sales_type").blur(function() {
    var id = $("#contract_sales_type").val();
    $.post('/contracts/sales_txn_type', {sales_type_id : id }, function(data) {
      $("#contract_sales_txn_type").autocomplete({source: data}); //$("#contract_sales_txn_type").html(data);
    });
    
    $.post('/contracts/sales_counselor', {sales_type_id : id }, function(data) {
      console.log(data);
      $("#contract_sales_primary_counselor").autocomplete({source: data});
      $("#contract_sales_secondary_counselor_1").autocomplete({source: data});
      $("#contract_sales_secondary_counselor_2").autocomplete({source: data});
      $("#contract_sales_secondary_counselor_3").autocomplete({source: data});
    });
    
    $.post('/contracts/payment_type', {sales_type_id : id }, function(data) {
      $(".down_payment_type").autocomplete({source: data});
    });
    
     $.post('/contracts/interest_term', {sales_type_id : id }, function(data) {
      $("#contract_interest_term").autocomplete({source: data});
    });
    
     $.post('/contracts/interest_method', {sales_type_id : id }, function(data) {
      $("#contract_interest_method").autocomplete({source: data});
    });
    
  });
  
  $("#contract_sales_txn_type").blur(function() {
    var id = $("#contract_sales_txn_type").val();
    $.post('/contracts/sales_lead_source', {sales_txn_type_id : id }, function(data) {
      $("#contract_sales_lead_source").autocomplete({source: data});
    });
  });
  
  $(".item_group_code").blur(function() {
    var id = this.id.match(/\d+/)[0];
    $.post('/contracts/item_category_code', {group_code_id : id }, function(data) {
      $("#contract_item_"+id+"_category_code").autocomplete({source: data});
    });
  });
})
