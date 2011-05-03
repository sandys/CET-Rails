class CompressQueue 
  @queue = :compress_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    zip = GenerateContract::ZIP.new(contract)
    zip.create
  end
end
