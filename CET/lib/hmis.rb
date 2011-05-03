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
    
    def get_sales_lead_source(sales_txn_type = nil)
      ["AQ - Acq Contract", "Special Event/Cremation", "Travel Protection Only", "Radiating Lead Source", "Advertising/Interment", "Emergency/First Call", "Telemarketer", "Special Event/Interment", "Employee", "Referral - Matt Pierson", "Transfer/Interment", "Walk-In/Interment", "Follow Up/Interment", "Walk-In/Cremation", "Transfer/Cremation", "Travel Protection and PAF/Cem PN", "Telephone Inquiry"]
    end
    
    def get_sales_counselor(sales_type_id = nil)
      {"Robert Lacey" => "1-Robert-Lacey", "John Brooks" => "2-John-Brooks", "Paul Shipman" => "3-Paul-Shipman", "Dennis Bonner" => "4-Dennis-Bonner", "House Account" => "5-House-Account", "Ben Upton" => "6-Ben-Upton", "John Carnes" => "7-John-Carnes", "Donald Garrison" => "8-Donald-Garrison", "Dale Granger" => "9-Dale-Granger", "Craig Wolf" => "10-Craig-Wolf"}
    end
    
    def name_types
      [ "Purchaser", "Co-purchaser", "Beneficiary", "Deceased"]
    end
    
    def discount_reason
      ["ICFA", "Manager Approved", "Insurance Allowance", "Pre-developed", "American Hero", "Emergency Burial Cert", "Senior Care Seminar", "Jewish Funeral Directors Assoc", "Trust Allowance", "Public Assistance", "Family Heritage", "Clergy", "Package Discount", "Competitor Match", "Davie", "Hospice Discount", "Preneed Tax Prepaid", "Promotional", "Infant Service", "Professional Courtesy", "Veteran Discount", "Charitable Discount", "Math Error", "Presentation", "Employee Discount", "Holiday Incentive", "Community Outreach"]
    end
	
  end
end
