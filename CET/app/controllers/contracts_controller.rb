class ContractsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit]
  
  def index
    @contracts = Contract.all
  end

  def new
    @contract = Contract.new
    @locations = HMIS::locations(current_user.email)
    @sales_need = HMIS::sales_need()
    @name_types = HMIS::name_types()
  end

  def create
    @contract = Contract.new(params[:contract])
    if @contract.save
      @contract.async_contract_entry(current_user.id)
      redirect_to contracts_url, :notice => "Successfully created contract."
    else
      render :action => 'new'
    end
  end

  def edit
    @contract = Contract.find(params[:id])
  end

  def update
    @contract = Contract.find(params[:id])
    if @contract.update_attributes(params[:contract])
      redirect_to contracts_url, :notice  => "Successfully updated contract."
    else
      render :action => 'edit'
    end
  end
  
  def sales_type
    location_id = params[:location_id].blank? ? nil : params[:location_id]
    @sale_types = location_id.blank? ? [] : HMIS::get_sales_type(location_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sale_types} }
     end
  end 
  
  def sales_txn_type
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @sales_txn_types = sales_type_id.blank? ? [] : HMIS::get_sales_txn_type(sales_type_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sales_txn_types } }
     end
  end  
  
  def sales_counselor
    sales_type_id = params[:sales_type_id].blank? ? nil : params[:sales_type_id]
    @sales_counselor = sales_type_id.blank? ? [] : HMIS::get_sales_counselor(sales_type_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @sales_counselor } }
     end
  end
  
  def sales_lead_source
    sales_txn_type_id = params[:sales_txn_type_id].blank? ? nil : params[:sales_txn_type_id]
    @lead_sources = sales_txn_type_id.blank? ? [] : HMIS::get_sales_lead_source(sales_txn_type_id)
     respond_to do |format|
       format.html{ render :partial => 'properties', :layout=>false, :locals => {:item => @lead_sources } }
     end
  end
end
