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
  
  attr_writer :current_step, :sales_batch_date, :sales_txn_date, :sales_date, :username, :sales_type, :sales_need, 
  :sales_txn_type, :sales_lead_source, :sales_primary_counselor, :sales_secondary_counselor_1
  
  def current_step
		@current_step || steps.first
	end
	
	def steps
		%w[contract_detail personal_detail item_detail payment_detail]
	end
	
	def next_step
		self.current_step = steps[steps.index(current_step) + 1]
	end
	
	def previous_step
		self.current_step = steps[steps.index(current_step) - 1 ]
	end
	
	def first_step?
		current_step == steps.first
	end
	
	def last_step?
		current_step == steps.last
	end
  
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
  
  def sales_batch_date
  	@sales_batch_date || self.data['sales_batch_date']
  end
  
  def sales_txn_date
  	@sales_txn_date || self.data['sales_txn_date']
  end
  
  def sales_date
  	@sales_date || self.data['sales_date']
  end
  
  def username
 		@username || self.data['username'] 	
  end
  
  def password
  	@password || self.data["password"]
  end
  
  def sales_type
  	@sales_type || self.data["sales_type"]
  end

	def sales_need
		@sales_need || self.data["sales_need"]	
	end
	
	def sales_txn_type
		@sales_txn_type || self.data["sales_txn_type"]
	end
	
	def sales_lead_source
		@sales_lead_source || self.data["sales_lead_source"]
	end
	
	def sales_primary_counselor
		@sales_primary_counselor  || self.data["sales_primary_counselor"]
	end
	
	def sales_secondary_counselor_1
		@sales_secondary_counselor_1 || self.data["sales_secondary_counselor_1"]
	end
	

end
