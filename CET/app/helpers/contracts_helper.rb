module ContractsHelper
	def select_box(id, collection , options = {} )
		options.merge!({:include_blank => true})
		select_tag(id, options_for_select(collection), options )
	end
end
