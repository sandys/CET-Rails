module HMIS
  class << self
    def locations(user_id = nil)
      {'101 Memorial House'=> 115, '102 Memorial House'=> 112}
    end

    def get_sales_type(location_id = nil)
      ["need", "forever"]
    end

    def sales_need
      ["At need", "Combination", "Pre need"]
    end

    def get_sales_txn_type(sale_type_id = nil)
      ["ANPNAN Atneed (PN ->AN)", 'New Contract', "Atneed (True)", "unfunded" , "PN NSMG Trust (New Sale)" ]
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
    
    def get_discount_reason
      ["ICFA", "Manager Approved", "Insurance Allowance", "Pre-developed", "American Hero", "Emergency Burial Cert", "Senior Care Seminar", "Jewish Funeral Directors Assoc", "Trust Allowance", "Public Assistance", "Family Heritage", "Clergy", "Package Discount", "Competitor Match", "Davie", "Hospice Discount", "Preneed Tax Prepaid", "Promotional", "Infant Service", "Professional Courtesy", "Veteran Discount", "Charitable Discount", "Math Error", "Presentation", "Employee Discount", "Holiday Incentive", "Community Outreach"]
    end
    
    def get_group_codes(location_id)
      ["Urn", "TN Fund Group", "Tennessee Sales Tax", "Special Codes", "Service", "Sales Tax", "Outer Burial Container", "Miscellaneous Merchandise", "Marker / Monument", "Kits", "Installation", "Generic Group", "Casket", "Base", "Alternative Containers"]
    end
    
    def get_category_codes(group_code)
      ["Tennessee Funeral Taxes", "Tennessee Cemetery Taxes"]
    end
    
    def get_interest_term(sale_type_id = nil)
      ["PN35%DN 84M15.9", "PN35%DN 24M15.9%", "84 Months", "48 Months", "72 Months 15.9%", "PN35%DN 12 Mos", "PN35%DN 48M9.9%", "24 Months 9.9%", "60 Months 9.9%", "PN35%DN 12M9.9%", "72 Months", "60 Months 15.9%", "PN35%DN 48M15.9%", "48 Months 15.9%", "PN35%DN 60M9.9%", "12 Months 9.9%", "PN35%DN 72M15.9%", "Cash Sale", "Paid In Full 1% Bonus", "PN35%DN 24M9.9%", "PN35%DN 36M9.9%", "Unfunded Prearrangement", "PN35%DN 48 Mos", "90 Day Same As Cash", "Cash Sale", "PN35%DN 60M15.9%", "24 Months", "12 Months", "120 MONTHS", "PN35%DN 84M9.9%", "PN35%DN 72 Mos", "108 Months", "12 Months 15.9%", "48 Months 9.9%", "36 Months 15.9%", "PN35%DN 18 Mos", "18 Months", "PN35%DN 24 Mos", "PN35%DN 72M9.9%", "36 Months", "PN35%DN 60 Mos", "24 Months 15.9%", "Paid In Full 2% Bonus", "PN35%DN 36 Mos", "PN35%DN 36M15.9%", "PN35%DN 12M15.9%", "84 Months 15.9%", "72 Months 9.9%", "60 Months", "84 Months 9.9%", "96 Months", "PN35%DN 84 Mos", "36 Months 9.9%", "PN35%DN 90 Days SAC"]      
    end
    
    def get_interest_method(sale_type_id = nil)
      ["Amortized/Deferred 9.9%", "Amortization / Deferred", "No Interest", "Amortized/Deferred 15.9%"]
    end
	
	  def get_down_payment_type(sale_type_id= nil)
	    ["Deferred Down Payment"]
	  end
	  
	  def file_upload_type
	    ["Account Adjustment Notes", "Accounting Copy", "Addendum FL Merch", "Affidavits", "AN Cemetery Contract", "AN Funeral Contract", "APD Authorization", "Assignment of PN Merchandise", "Auth for Cremation and Disposition", "Away from Home Documents (TPP)", "Bankruptcy Documents", "Burial Permits", "California Compliance Forms", "Cancellation Application", "Cancellation Request", "Cash Receipt", "Cemetery Correspondence", "Certificate of Credit", "Certificate of Performance", "Certificate of Services Received", "Certificate of Title of Stored Markers", "Change of Beneficiary", "Check Return Notice", "Collection Letters", "Compliance Checklist", "Contract Adjustments", "Contract Customer Correspondence", "Corporate Use, Trust Only", "Data Entry Worksheet", "Death Certificate", "Death Maturity Forms", "Down Payment", "Family Protection Plan Documents", "Floral Photo", "General Price List with AN and PN", "Grandchild Protection Documents", "Grantor Letters", "Ins Application or Ins Forms", "Installation WO", "Interment Order or Authorization", "Letters of Testamentary", "Loss Affidavit or Affidavit of Loss", "Marker", "MEMs (Making Everlasting Memories)", "PN Cemetery Contract", "PN Funeral Contract", "Power of Attorney", "Pre-Need to At-Need Worksheet", "Receipt for Delivery", "Recurring Credit Card Payments", "Refund Check or CC Reversal", "Report of Death Beneficiary", "Sales Solicitation Letters to Customer", "Transfer Forms", "Transit Permit", "Unfunded Documents", "Unfunded Selection Document ", "Withdrawal Checklist", "Write-Off Form"]
	  end
	  
  end
end
