class ContractsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit]
  
  def index
    @contracts = Contract.all
  end

  def new
    @contract = Contract.new
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
end
