module ContractsHelper
	def select_box(id, options )
		select_tag id, options_for_select(options), { :include_blank => true } 
	end
end
