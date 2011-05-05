class Contract < ActiveRecord::Base
  validates_presence_of :contract_no, :location_id
  validates_uniqueness_of :contract_no
  validates_numericality_of :contract_no, :on => [:create, :update]
  validates_numericality_of :location_id, :on => [:create, :update]
  
  attr_accessible :contract_no, :location_id
  belongs_to :user
  
  
  before_save :json_serialize
  #after_save  :json_deserialize
  #after_find  :json_deserialize

  def json_serialize  
  self.data = ActiveSupport::JSON.encode(self.attributes['data'])
  end

  def json_deserialize
  unless (self.attributes['data'].nil?)
    self.data = ActiveSupport::JSON.decode(self.attributes['data'].to_s)
  end
  end

  
  def async_contract_entry
    Resque.enqueue(PdfQueue, self.id)
    Resque.enqueue(XlsQueue, self.id)
    Resque.enqueue(CompressQueue, self.id)
    Resque.enqueue(MailQueue, self.id)
  end
  
  #def create_pdf
  #  GenerateContract::PDF.create(self)
  #end
  
end
