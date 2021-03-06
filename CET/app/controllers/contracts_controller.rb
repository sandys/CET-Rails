class ContractsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :edit]
  
  def index
    @contracts = current_user.contracts.all rescue nil
    session[:cstep] = session[:cparams] = nil
    respond_to do |format|
       format.html{ }
    end
  end

  def new
    session[:cparams] ||= {}
    @contract = current_user.contracts.new(session[:cparams])
    @contract.data = session[:cparams]
    @users = HMIS::users
    #@locations = HMIS::locations(current_user.email)
    @sales_need = HMIS::sales_need()
    @name_types = HMIS::name_types()
    @discount_reason = HMIS::get_discount_reason
    #@upload_type = HMIS::file_upload_type
    session[:cstep] = params['q'].blank? ? session[:cstep] : params['q']
    @contract.current_step = session[:cstep]
    if @contract.current_step == "personal_detail"
        @personal_details = session[:cparams]["personal"] unless session[:cparams]["personal"].nil?
    end
    if @contract.current_step == "item_detail"
        @item_details = session[:cparams]["item"] unless session[:cparams]["item"].nil?
    end
    
    if @contract.current_step == "payment_detail"
        @payment_details = session[:cparams]["payment"] unless session[:cparams]["payment"].nil?
        @interest_term =  session[:cparams]["interest_term"].nil? ? "" : session[:cparams]["interest_term"]
        @interest_payment_start_date = session[:cparams]["interest_payment_start_date"].nil? ? "" : session[:cparams]["interest_payment_start_date"] 
        @interest_method = session[:cparams]["interest_method"].nil? ? "" : session[:cparams]["interest_method"] 
        @interest_rate = session[:cparams]["interest_rate"].nil? ? "" : session[:cparams]["interest_rate"] 
        @interest_free_days = session[:cparams]["interest_free_days"].nil? ? "" : session[:cparams]["interest_free_days"] 
        @interest_forgive = session[:cparams]["interest_forgive"].nil? ? "" : session[:cparams]["interest_forgive"] 
    end
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    session[:cparams].deep_merge!(params[:contract]) if params[:contract]
    @contract = current_user.contracts.new(session[:cparams])
    @contract.current_step = session[:cstep]
    @contract.data = session[:cparams] #JSON.parse(params[:contract].to_json)
    
    if @contract.valid?
      if params[:back_button]
        @contract.previous_step
      elsif @contract.last_step?
        @contract.save #if @order.all_valid?
      else
        @contract.next_step
      end
      session[:cstep] = @contract.current_step
    end
    
    
    respond_to do |format|
      unless @contract.new_record?
        @contract.async_contract_entry()
        session[:cstep] = session[:cparams] = nil
        format.html{ redirect_to contracts_url, :notice => "Your contract has been queued for generation. You will receive an email with all files shortly at #{current_user.email}" }
      else
        #flash[:error] = "Error Occured"
        format.html { redirect_to(:action => "new") }
      end
     end
  end

  def edit
    session[:cparams] ||= {}
    @contract = current_user.contracts.find(params[:id])
    session[:cparams] = @contract.data #json_deserialize

    @users = HMIS::users
    #@locations = HMIS::locations(current_user.email)
    @sales_need = HMIS::sales_need()
    @name_types = HMIS::name_types()
    @discount_reason = HMIS::get_discount_reason
    #@upload_type = HMIS::file_upload_type
    session[:cstep] = params['q'].blank? ? session[:cstep] : params['q']
    @contract.current_step = session[:cstep]
    if @contract.current_step == "personal_detail"
        @personal_details = session[:cparams]["personal"] unless session[:cparams]["personal"].nil?
    end
    if @contract.current_step == "item_detail"
        @item_details = session[:cparams]["item"] unless session[:cparams]["item"].nil?
    end
    
    if @contract.current_step == "payment_detail"
        @payment_details = session[:cparams]["payment"] unless session[:cparams]["payment"].nil?
        @interest_term =  session[:cparams]["interest_term"].nil? ? "" : session[:cparams]["interest_term"]
        @interest_payment_start_date = session[:cparams]["interest_payment_start_date"].nil? ? "" : session[:cparams]["interest_payment_start_date"] 
        @interest_method = session[:cparams]["interest_method"].nil? ? "" : session[:cparams]["interest_method"] 
        @interest_rate = session[:cparams]["interest_rate"].nil? ? "" : session[:cparams]["interest_rate"] 
        @interest_free_days = session[:cparams]["interest_free_days"].nil? ? "" : session[:cparams]["interest_free_days"] 
        @interest_forgive = session[:cparams]["interest_forgive"].nil? ? "" : session[:cparams]["interest_forgive"] 
    end
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def update
    session[:cparams].deep_merge!(params[:contract]) if params[:contract]
    @contract = current_user.contracts.find(params[:id])
    @contract.current_step = session[:cstep]
    @contract.data = session[:cparams] #JSON.parse(params[:contract].to_json)
    
    respond_to do |format|
      @contract.update_attributes(:contract_no => @contract.data["contract_no"], :location_id => @contract.data["location_id"])
      if params[:back_button]
        @contract.previous_step
      elsif @contract.last_step?
        session[:cstep] = session[:cparams] = nil
        @contract.async_contract_entry()
        format.html{ redirect_to contracts_url, :notice => "Your contract has been queued for generation. You will receive an email with all files shortly at #{current_user.email}" }
      else
        @contract.next_step
      end
      session[:cstep] = @contract.current_step
      format.html { redirect_to(:action => "edit") }
    end
  end
  
  def customer_search
    fname = params[:customer_search][:fname].downcase == "first name"  ? "" : params[:customer_search][:fname]
    lname = params[:customer_search][:lname].downcase == "last name"  ? "" : params[:customer_search][:fname]
    zipcode = params[:customer_search][:zipcode].downcase == "zipcode"  ? "" : params[:customer_search][:fname]
    phone = params[:customer_search][:phone].downcase == "phone"  ? "" : params[:customer_search][:fname]
    @result = HMIS::customer_search(:first_name => fname, :last_name => lname, :zipcode => zipcode, :phone => phone)
    respond_to do |format|
       format.json{ render :json => @result }
     end
  end
  
  def item_search
    code, desc, group_code, category_code = params[:item_search][:item_code],params[:item_search][:item_desc], params[:item_search][:group_code], params[:item_search][:category_code]
    @result = HMIS::item_search(:code => code, :desc => desc, :group_code => group_code, :category_code => category_code)
    respond_to do |format|
       format.json{ render :json => @result }
     end 
  end
  
  def usernames
    @users = HMIS::users
     respond_to do |format|
       format.json{ render :json => @users }
     end
  end
  
  def user_password
    user_id = params[:user_id].blank? ? nil : params[:user_id]
    @password = user_id.blank? ? [] : HMIS::user_password(user_id)
     respond_to do |format|
       format.html{ render :text => @password }
     end
  end
  
  def user_location
    user_id = params[:user_id].blank? ? nil : params[:user_id]
    @locations = user_id.blank? ? [] : HMIS::locations(user_id)
     respond_to do |format|
       format.json{ render :json => @locations }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @locations} }
     end
  end
  
  def sales_type
    location_id = params[:location_id].blank? ? nil : params[:location_id]
    @sale_types = location_id.blank? ? [] : HMIS::get_sales_type(location_id)
     respond_to do |format|
       format.json{ render :json => @sale_types }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sale_types} }
     end
  end 
  
  def sales_txn_type
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @sales_txn_types = sales_type_id.blank? ? [] : HMIS::get_sales_txn_type(sales_type_id)
     respond_to do |format|
       format.json{ render :json => @sales_txn_types }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sales_txn_types } }
     end
  end  
  
  def sales_counselor
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @sales_counselor = sales_type_id.blank? ? [] : HMIS::get_sales_counselor(sales_type_id)
     respond_to do |format|
       format.json{ render :json => @sales_counselor }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sales_counselor } }
     end
  end
  
  def sales_lead_source
    sales_txn_type_id = params[:sales_txn_type_id].blank? ? nil : params[:sales_txn_type_id]
    @lead_sources = sales_txn_type_id.blank? ? [] : HMIS::get_sales_lead_source(sales_txn_type_id)
     respond_to do |format|
       format.json{ render :json => @lead_sources }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @lead_sources } }
     end
  end
  
  def item_group_code
    location_id = params[:location_id].blank? ? nil : params[:location_id]
    @group_codes = location_id.blank? ? [] : HMIS::get_group_codes(location_id)
     respond_to do |format|
       format.json{ render :json => @group_codes }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @group_codes } }
     end
  end
  
  def item_category_code
    group_code_id = params[:group_code_id].blank? ? nil : params[:group_code_id]
    @category_codes = group_code_id.blank? ? [] : HMIS::get_category_codes(group_code_id)
     respond_to do |format|
       format.json{ render :json => @category_codes }
       #format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @category_codes } }
     end
  end
  
  def payment_type
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @payment_type = sales_type_id.blank? ? [] : HMIS::get_down_payment_type(sales_type_id)
     respond_to do |format|
       format.json{ render :json => @payment_type }
     end
  end
  
  def interest_term
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @interest_term = sales_type_id.blank? ? [] : HMIS::get_interest_term(sales_type_id)
     respond_to do |format|
       format.json{ render :json => @interest_term }
     end
  end
  
  def interest_method
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @interest_method = sales_type_id.blank? ? [] : HMIS::get_interest_method(sales_type_id)
     respond_to do |format|
       format.json{ render :json => @interest_method }
     end
  end
  
  def recieve_payment
    payment_details = params[:recieve_payment].blank? ? nil : params[:recieve_payment]
    card_number, full_name, expiry_month, expiry_year, cvv, amount = payment_details["full_name"], payment_details["card_number"], payment_details["expiry_date(2i)"], payment_details["expiry_date(1i)"], payment_details["cvv"], payment_details["amount"] unless payment_details.blank?
    
    respond_to do |format|
     if (card_number.present? and full_name.present? and expiry_month.present? and expiry_year.present? and cvv.present? and amount.present?)
       if payment_details["card_number"].to_i == 4111111111111111 
          format.json{ render :json => {:success => "Payment Recieved Successfully"} }
       else
          format.json{ render :json => {:error  => "Credit Card Declined"} }
       end
     else
       format.json{ render :json => {:error => "Please fill in all the details"} }
     end
    end
  end
end
