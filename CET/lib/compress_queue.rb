class CompressQueue 
  @queue = :compress_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    user = ActiveRecord::Base::User.find(contract.user_id)
    data = ActiveSupport::JSON.decode(contract.data.to_s)
    zip = GenerateContract::ZIP.new(data)
    zip.create
  end
end
