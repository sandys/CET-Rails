class ContractsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :edit]
  
  def index
    @contracts = current_user.contracts.all
    session[:cstep] = session[:cparams] = nil
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
    
    @contract.current_step = session[:cstep]
    if @contract.current_step == "personal_detail"
        @personal_details = session[:cparams]["personal"] unless session[:cparams]["personal"].nil?
    end
    if @contract.current_step == "item_detail"
        @item_details = session[:cparams]["item"] unless session[:cparams]["item"].nil?
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
        #@contract.async_contract_entry()
        session[:cstep] = session[:cparams] = nil
        format.html{ redirect_to contracts_url, :notice => "Contract created successfully." }
      else
        #flash[:error] = "Error Occured"
        format.html { redirect_to(:action => "new") }
      end
     end
  end

  def edit
    session[:cparams] ||= {}
    @contract = current_user.contracts.find(params[:id])
    session[:cparams] = @contract.json_deserialize

    @users = HMIS::users
    #@locations = HMIS::locations(current_user.email)
    @sales_need = HMIS::sales_need()
    @name_types = HMIS::name_types()
    @discount_reason = HMIS::get_discount_reason
    #@upload_type = HMIS::file_upload_type
    
    @contract.current_step = session[:cstep]
    if @contract.current_step == "personal_detail"
        @personal_details = session[:cparams]["personal"] unless session[:cparams]["personal"].nil?
    end
    if @contract.current_step == "item_detail"
        @item_details = session[:cparams]["item"] unless session[:cparams]["item"].nil?
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
      if params[:back_button]
        @contract.previous_step
      elsif @contract.last_step?
        @contract.update_attributes(:data => @contract.data, :contract_no => @contract.data["contract_no"], :location_id => @contract.data["location_id"])
        session[:cstep] = session[:cparams] = nil
        format.html{ redirect_to contracts_url, :notice => "Contract updated successfully." }
      else
        @contract.next_step
      end
      session[:cstep] = @contract.current_step
      @contract.update_attributes(:data => @contract.data, :contract_no => @contract.data["contract_no"], :location_id => @contract.data["location_id"])
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
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @payment_type } }
     end
  end
  
  def interest_term
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @interest_term = sales_type_id.blank? ? [] : HMIS::get_interest_term(sales_type_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @interest_term } }
     end
  end
  
  def interest_method
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @interest_method = sales_type_id.blank? ? [] : HMIS::get_interest_method(sales_type_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @interest_method } }
     end
  end
end
