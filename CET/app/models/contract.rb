class Contract < ActiveRecord::Base
  attr_accessible :name, :phone
  
  def async_contract_entry(user_id)
    Resque.enqueue(PdfQueue, self.id)
    Resque.enqueue(XlsQueue, self.id)
    Resque.enqueue(CompressQueue, self.id)
    Resque.enqueue(MailQueue, self.id, user_id)
  end
  
  #def create_pdf
  #  GenerateContract::PDF.create(self)
  #end
  
end
