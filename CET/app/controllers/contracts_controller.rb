class ContractsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index, :new, :edit]
  
  def index
    @contracts = current_user.contracts.all
  end

  def new
    session[:cparams] ||= {}
    @contract = current_user.contracts.new(session[:cparams])
    @contract.data = session[:cparams]

    puts "******************************#{session[:cparams].inspect}"
    puts "****************************#{@contract.inspect}"
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
    @contract = current_user.contracts.find(params[:id])
    @users = HMIS::users
    #@locations = HMIS::locations(current_user.email)
    @sales_need = HMIS::sales_need()
    @name_types = HMIS::name_types()
    @discount_reason = HMIS::get_discount_reason
    @upload_type = HMIS::file_upload_type
  end

  def update
    @contract = current_user.contracts.find(params[:id])
    respond_to do |format|
      if @contract.update_attributes(:data => params[:contract])
        #@contract.async_contract_entry(current_user.id)
        format.html{ redirect_to contracts_url, :notice => "Successfully updatedcreated contract." }
      else
        #flash[:error] = "Error Occured"
        format.html{ redirect_to(:action => "edit") }
      end
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
       format.json{ render :json => category_codes }
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
