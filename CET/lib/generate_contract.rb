require 'prawn'
require "prawn/measurement_extensions"
require 'zip/zipfilesystem'

module GenerateContract

	class PDF
		def self.create(contract)
			pdf = Prawn::Document.new(:page_layout => :portrait, :left_margin => 1.cm, :right_margin => 1.cm, :top_margin => 1.cm,  :bottom_margin => 1.cm, :page_size => 'A4')
			pdf.text "Your Name: #{contract.name}"
			pdf.move_down(20)
			pdf.text "Mobile Number: #{contract.phone}"
			pdf.render_file(Rails.root.join('files/pdf',"#{contract['location_id']}_#{contract['contract_no']}.pdf"))
		end
	end
	
	
	class XLS
		def self.create(contract, user)
			book = Spreadsheet::Workbook.new
			sheet = book.create_worksheet :name => "data"
			sheet.row(0).push "Location", contract["location_id"], "", "Batch_Date", contract["sales_batch_date"], "", "Txn_Date", contract["sales_txn_date"]
			sheet.row(1).push "Contract_Number", contract["contract_no"]
			sheet.row(2).push "Sales_Type", contract["sales_type"], "", "User Name", user.email, "", "Password", ""
			sheet.row(3).push "Txn_Type", contract["sales_txn_type"], "", "HMIS URL", contract["hmis_url"]
			sheet.row(4).push "Sales_Date", contract["sales_date"], "", "Terms", contract["interest_term"], "", "Payment_Start_Date", contract["interest_payment_start_date"], "", "Interest_Method", contract["interest_method"]
			sheet.row(5).push "Sales_Need", contract["sales_need"], "", "Interest_Rate", contract["interest_rate"], "", "Days_Interest_Free", contract["interest_free_days"], "", "Forgive_Interest", contract["interest_forgive"]
			sheet.row(6).push "Lead_Source", contract["sales_lead_source"]
			sheet.row(7).push "Primary_Arranger", contract["sales_primary_counselor"], "", "", "Secondary_Arranger1", contract["sales_secondary_counselor_1"], "", "", "Secondary_Arranger2", contract["sales_secondary_counselor_2"], "", "", "Secondary_Arranger3", contract["sales_secondary_counselor_3"]
			sheet.row(8).push "Name_Type", "First_Name", "Middle_Name", "Last_Name", "Address", "City", "State", "Zip", "Phone", "DOB", "DOD", "SS No.", "Name_Id", "", "", "Down_Pymt_Dt", "Amount", "Down_Pymt_Type", "Remarks"
			
			sheet.row(19).push "Item_Cd", "Item_Descr", "Quantity", "Price", "Discount", "Discount_Reason", "Sales_Need", "", "", "", "", "", "", "", "", "Image Name", " Document Type", "Uploaded Image"
			contract["item"].each do |key,value| 
				unless value['final_code'].blank? 
					sheet.row(key.to_i+19).push value['final_code'], value['final_desc'], value['quantity'], value['price'], value['discount'], value["discount_reason"], value["sales_need"]
				else
					sheet.row(key.to_i+19).push "", "", "", "", "", "", ""
				end
			end
			
			contract["personal"].each do |key,value| 
				unless (value['first_name'].blank? and value['last_name'].blank?)
					sheet.row(key.to_i+8).push value['name_type'], value['first_name'], value['middle_name'], value['last_name'], value['address'], value["city"], value["state"], value["zipcode"], value["phone"], value["dob"], value["dod"], value["ssn"], ""
				else
					sheet.row(key.to_i+8).push "", "", "", "", "", "", "", "", "", "", "", "", ""
				end
			end
			
			contract["file"].each do |key,value| 
				unless value['image_name'].blank? 
					sheet.row(key.to_i+19).concat ["", "", "", "", "", "", "", "", value["image_name"], value["upload_type"], ""]
				else
					sheet.row(key.to_i+19).concat ["", "", "", "", "", "", "", "", "", "", ""]
				end
			end
			
			
			contract["payment"].each do |key,value| 
				unless value['amount'].blank? 
					sheet.row(key.to_i+8).concat ["", "", value["date"], value["amount"], value['type'], value['remark']]
				else
					sheet.row(key.to_i+8).concat ["", "", "", "", "", ""]
				end
			end
			
			book.write(Rails.root.join('files/xls',"#{contract['location_id']}_#{contract['contract_no']}.xls"))
		end
	end
	
	
	class ZIP
		attr_accessor :list_of_file_paths, :zip_file_path

		def initialize(contract)
			filename = "#{contract.id}_#{contract.name}"
      @zip_file_path = Rails.root.join('files/compress', "#{filename}.zip")
      @list_of_file_paths = [Rails.root.join('files/pdf',"#{filename}.pdf"), Rails.root.join('files/xls', "#{filename}.xls")]
		end

		def create
		  zip = Zip::ZipFile.open(self.zip_file_path, Zip::ZipFile::CREATE) do | zipfile |
		    @list_of_file_paths.each do | file_path |
		      if File.exists?file_path
		        file_name = File.basename( file_path )
		        if zipfile.find_entry( file_name )
		        	zipfile.replace( file_name, file_path )
		        else
		        	zipfile.add( file_name, file_path)
		        end
		      else
		      	puts "Warning: file #{file_path} does not exist"
		      end
		    end
		  end
		end
	end
		
end
