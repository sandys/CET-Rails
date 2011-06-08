// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#contract_sales_batch_date").datepicker();
  $("#contract_sales_txn_date").datepicker();
  $("#contract_sales_date").datepicker();
  $(".down_payment_date").datepicker();
  $("#contract_interest_payment_start_date").datepicker();
  
  $("#contract_username").click(function() {
    $.post('/contracts/usernames', {}, function(data) {
      $("#contract_username").autocomplete({source: data, 
        select: function(event, ui) {
          var id = ui["item"]["value"];
          $.post('/contracts/user_password', {user_id : id }, function(data) {
            $("#contract_password").val(data);
          });
          
          $.post('/contracts/user_location', {user_id : id }, function(data) {
            // $("#contract_location_id").html(data);
            $("#contract_location_id").autocomplete({source: data, 
              select: function(event, ui) {
                var id = ui["item"]["value"];
                $.post('/contracts/sales_type', {location_id : id }, function(data) {
                  $("#contract_sales_type").autocomplete({source: data,
                    select: function(event, ui) {
                      var id = ui["item"]["value"];
                      $.post('/contracts/sales_txn_type', {sales_type_id : id }, function(data) {
                        $("#contract_sales_txn_type").autocomplete({source: data, 
                          select: function(event, ui) {
                            var id = ui["item"]["value"];
                            $.post('/contracts/sales_lead_source', {sales_txn_type_id : id }, function(data) {
                              $("#contract_sales_lead_source").autocomplete({source: data}).removeClass("ac_dis_field").addClass("ac_field");
                            });
                          }
                        }).removeClass("ac_dis_field").addClass("ac_field"); 
                      });
                    
                      $.post('/contracts/sales_counselor', {sales_type_id : id }, function(data) {
                        $("#contract_sales_primary_counselor").autocomplete({source: data}).removeClass("ac_dis_field").addClass("ac_field");
                        $("#contract_sales_secondary_counselor_1").autocomplete({source: data}).removeClass("ac_dis_field").addClass("ac_field");
                        $("#contract_sales_secondary_counselor_2").autocomplete({source: data}).removeClass("ac_dis_field").addClass("ac_field");
                        $("#contract_sales_secondary_counselor_3").autocomplete({source: data}).removeClass("ac_dis_field").addClass("ac_field");
                      });
                    }
                  }).removeClass("ac_dis_field").addClass("ac_field");
                });
              }
            }).removeClass("ac_dis_field").addClass("ac_field");
          });
        }
      });
      $("#contract_username").autocomplete("search", $(this).val());
    });
  });
    
  // auto focus of all the options
  
  $("#contract_location_id").focus(function() {
    $("#contract_location_id").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_type").focus(function(){
     $("#contract_sales_type").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_need").focus(function(){
    $("#contract_sales_need").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_txn_type").focus(function(){
     $("#contract_sales_txn_type").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_primary_counselor").focus(function(){
      $("#contract_sales_primary_counselor").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_secondary_counselor_1").focus(function(){
      $("#contract_sales_secondary_counselor_1").autocomplete( "search", $(this).val());
  });
  
  $("#contract_sales_lead_source").focus(function(){
    $("#contract_sales_lead_source").autocomplete( "search", $(this).val());
  });
  
  $("#item_search_group_code").focus(function(){
    $("#item_search_group_code").autocomplete( "search", $(this).val());
  });
  
  $("#item_search_category_code").focus(function() {
    $("#item_search_category_code").autocomplete( "search", $(this).val());
  });
  
  $("#contract_interest_method").focus(function(){
    $("#contract_interest_method").autocomplete( "search", $(this).val());
  });
  
  $("#contract_interest_term").focus(function(){
    $("#contract_interest_term").autocomplete( "search", $(this).val());
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
  
  $("#financing_options").click(function(){
    $("#cc_payment_void").hide();
    $("#cc_payment_details").hide();
    $("#financing_options_details").show();
    event.preventDefault();
  });
  
  $("#cc_payment").click(function(){
    $("#financing_options_details").hide();
    $("#cc_payment_void").show();
    $("#cc_payment_details").show();
    event.preventDefault();
  });
  
  $("#recieve_payment").submit(function(event){
    event.preventDefault(); 
    $.post( '/contracts/recieve_payment', $(this).serialize(),
      function( data ) {
        if(data["error"]) {
          $("#cc_payment_details .success").hide();
          $("#cc_payment_details .error").html(data["error"]).show();
        }
        else if(data["success"]){
          $("#cc_payment_details .error").hide();
          $("#cc_payment_details .success").html(data["success"]).show();
          $("#cc_payment_details input[name*='recieve_payment']").val("");
          $("#cc_payment_details select").val("");
        }
      });
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

jQuery.fn.clearRow = function(number){
  $("input[name*="+ number +"]").each(function(){
    $(this).val("");
  });
};


jQuery.fn.group_codes = function(location_id){
  $.post('/contracts/item_group_code', {location_id : location_id }, function(data) {
      $("#item_search_group_code").autocomplete({source: data,
        select: function(event, ui){
          var id = ui["item"]["value"];
          $.post('/contracts/item_category_code', {group_code_id : id }, function(data) {
           $("#item_search_category_code").autocomplete({source: data});
          });
        }
      });
  });
};

function paymentDetails(sales_type_id){
  //$.post('/contracts/payment_type', {sales_type_id : sales_type_id }, function(data) {
    //$(".down_payment_type").autocomplete({source: data});
    //$(".down_payment_type").autocomplete( "search", $(this).val());
  //});
  
   $.post('/contracts/interest_term', {sales_type_id : sales_type_id }, function(data) {
    $("#contract_interest_term").autocomplete({source: data});
  });
  
   $.post('/contracts/interest_method', {sales_type_id : sales_type_id }, function(data) {
    $("#contract_interest_method").autocomplete({source: data});
  });
}
