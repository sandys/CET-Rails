class PdfQueue 
  @queue = :pdf_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    user = ActiveRecord::Base::User.find(contract.user_id)
    data = ActiveSupport::JSON.decode(contract.data.to_s)
    GenerateContract::PDF.create(data, user)
  end
end
