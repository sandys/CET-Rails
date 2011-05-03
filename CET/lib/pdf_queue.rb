class PdfQueue 
  @queue = :pdf_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    GenerateContract::PDF.create(contract)
  end
end
