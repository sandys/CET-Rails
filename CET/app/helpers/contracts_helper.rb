module ContractsHelper
	def select_box(id, collection , options = {} )
		{:include_blank => true}.merge!(options)
		select_tag(id, options_for_select(collection), options )
	end
	
	def total_cost(contract)
		items = contract.data["item"]
		total_cost = 0
		(1..items.length).each do |i|
			price = items[i.to_s]["price"].to_f * items[i.to_s]["quantity"].to_i
			discount = price * items[i.to_s]["discount_percent"].to_f / 100
			total_cost += (price - discount)
		end
		return total_cost
	end
end
