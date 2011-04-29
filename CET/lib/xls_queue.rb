class XlsQueue 
  @queue = :xls_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    GenerateContract::XLS.create(contract)
  end
end
