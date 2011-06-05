class XlsQueue 
  @queue = :xls_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    user = ActiveRecord::Base::User.find(contract.user_id)
    data = contract.data #ActiveSupport::JSON.decode(contract.data.to_s)
    GenerateContract::XLS.create(data, user)
  end
end
