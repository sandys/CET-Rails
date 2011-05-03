module HMIS
  class << self
    def locations(user_id = nil)
      {'101 Memorial House'=> 1, '102 Memorial House'=> 2}
    end

    def get_sales_type(location_id = nil)
      ["need", "forever"]
    end

    def sales_need
      ["At need", "Combination", "Pre need"]
    end

    def get_sales_txn_type(sale_type_id = nil)
      {"ANPNAN Atneed (PN ->AN)"=> 1, 'New Contract'=> 2, "Atneed (True)" => 3, "unfunded" => 4, "PN NSMG Trust (New Sale)" => 5}
    end
	
  end
end
