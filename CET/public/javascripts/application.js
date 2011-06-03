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
  
  
  // CUSTOMER DETAILS SEARCH AJAX FORM SUBMIT
  $("#customer_search").submit(function(event){
    event.preventDefault(); 

    /* Send the data using post and put the results in a div */
    $.post( '/contracts/customer_search', $(this).serialize(),
      function( data ) {
          var match = $("input[name*='first_name']").filter(function(index){ 
            if ($(this).val()== ""){ 
              return $(this);
            }
          }).filter(":first")[0].id.match(/\d+/)[0];
         $("#contract_personal_" + match + "_first_name").val(data["first_name"]);
         $("#contract_personal_" + match + "_middle_name").val(data["middle_name"]);
         $("#contract_personal_" + match + "_last_name").val(data["last_name"]);
         $("#contract_personal_" + match + "_zipcode").val(data["zipcode"]);
         $("#contract_personal_" + match + "_address").val(data["address"]);
         $("#contract_personal_" + match + "_city").val(data["city"]);
         $("#contract_personal_" + match + "_state").val(data["state"]);
         $("#contract_personal_" + match + "_phone").val(data["phone"]);
      }
    );
  });
  
  
  // ITEM SEARCH DETAILS AJAX SUBMIT
  $("#item_search").submit(function(event){
    event.preventDefault(); 

    /* Send the data using post and put the results in a div */
    $.post( '/contracts/item_search', $(this).serialize(),
      function( data ) {
          console.log(data);
          var match = $("input[name*='final_code']").filter(function(index){ 
            if ($(this).val()== ""){ 
              return $(this);
            }
          }).filter(":first")[0].id.match(/\d+/)[0];
         $("#contract_item_" + match + "_final_code").val(data["code"]);
         $("#contract_item_" + match + "_final_desc").val(data["description"]);
         $("#contract_item_" + match + "_quantity").val(data["quantity"]);
         $("#contract_item_" + match + "_price").val(data["price"]);
         $("#contract_item_" + match + "_discount_percent").val(data["discount_percent"]);
         $("#contract_item_" + match + "_discount_reason").val(data["discount_reason"]);
      }
    );
  });
})


// Clear field on focus and remove class dull-txt
jQuery.fn.clearfield = function(txt){
  if (this.val() == txt) {
    this.val('');
    this.removeClass("dull-txt");
   }
};

// Set the default value in text field and add the class dull-txt
jQuery.fn.resetfield = function(txt){
  if (this.val() == "") {
    this.val(txt);
    this.addClass("dull-txt");
   }
};
