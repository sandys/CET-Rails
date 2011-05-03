module ContractsHelper
	def select_box(id, collection , options = {} )
		options = {:include_blank => true}.merge(options)
		select_tag id, options_for_select(collection), options 
	end
end
