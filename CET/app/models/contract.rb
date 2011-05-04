class Contract < ActiveRecord::Base
  validates_presence_of :contract_no, :location_id
  validates_uniqueness_of :contract_no
  validates_numericality_of :contract_no, :on => [:create, :update]
  validates_numericality_of :location_id, :on => [:create, :update]
  
  attr_accessible :date
  
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
