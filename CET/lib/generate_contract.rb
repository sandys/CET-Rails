require 'prawn'
require 'prawn/layout'
require "prawn/measurement_extensions"
require 'zip/zipfilesystem'

module GenerateContract

	class PDF
		def self.create(contract, user)
			pdf = Prawn::Document.new(:page_layout => :portrait, :left_margin => 1.cm, :right_margin => 1.cm, :top_margin => 1.cm,  :bottom_margin => 1.cm, :page_size => 'A4')
			pdf.text "Location: #{contract[:location_id.to_s]}"
			pdf.move_down(5)
			pdf.text "Contract Number: ##{contract[:contract_no.to_s]}"
			pdf.move_down(5)
			pdf.text "Batch_Date: #{contract[:sales_batch_date.to_s]}"
			pdf.move_down(5)
			pdf.text "Txn_Date: #{contract[:sales_txn_date.to_s]}"
			pdf.move_down(5)
			pdf.text "Sales Type: #{contract[:sales_type.to_s]}"
			pdf.move_down(5)
			pdf.text "User Name: #{user.email}, Password: "
			pdf.move_down(5)
			pdf.text "Txn_Type: #{contract[:sales_txn_type.to_s]}"
			pdf.move_down(5)
			pdf.text "HMIS URL: #{contract[:hmis_url.to_s]}"
			pdf.move_down(5)
			pdf.text "Sales Date: #{contract[:sales_date.to_s]}"
			pdf.move_down(20)
			pdf.text "Terms: #{contract[:interest_term.to_s]}, Payment Start Date: #{contract[:interest_payment_start_date.to_s]}, Interest Method: #{contract[:interest_method.to_s]}"
			pdf.move_down(5)
			pdf.text "Sales Need: #{contract[:sales_need.to_s]}, Interest Rate: #{contract[:interest_rate.to_s]}, Days Interest Free: #{contract[:interest_free_days.to_s]}, Forgive Interest: #{contract[:interest_forgive.to_s]}"
			pdf.move_down(5)
			pdf.text "Lead Source: #{contract[:sales_lead_source.to_s]}"
			pdf.move_down(5)
			pdf.text "Primary Arranger: #{contract[:sales_primary_counselor.to_s]}, Secondary Arranger1: #{contract[:sales_secondary_counselor_1.to_s]}, Secondary Arranger2: #{contract[:sales_secondary_counselor_2.to_s]}, Secondary Arranger3: #{contract[:sales_secondary_counselor_3.to_s]}"
			pdf.move_down(20)
			
			personal_details = contract["personal"].map do |key,value| 
				unless (value['first_name'].blank? and value['last_name'].blank?)
					[ value[:name_type.to_s], 
						value[:first_name.to_s],
						value[:middle_name.to_s], 
						value[:last_name.to_s], 
						value[:address.to_s], 
						value[:city.to_s], 
						value[:state.to_s], 
						value[:zipcode.to_s], 
						value[:phone.to_s], 
						value[:dob.to_s], 
						value[:dod.to_s], 
						value[:ssn.to_s]
					]
				else
					["", "", "", "", "", "", "", "", "", "", "", ""]
				end
			end
			pdf.table personal_details, :row_colors => ["FFFFFF", "DDDDDD"] 
			#, :headers => ["Name Type", "First Name", "Middle Name", "Last Name", "Address", "City", "State", "Zip", "Phone", "DOB", "DOD", "SS No.", "Name Id"] 
			
			pdf.move_down(20)
			personal_items= contract["item"].map do |key,value| 
				unless value['final_code'].blank? 
					[ value[:final_code.to_s],  
						value[:final_desc.to_s], 
						value[:quantity.to_s], 
						value[:price.to_s], 
						value[:discount.to_s], 
						value[:discount_reason.to_s], 
						value[:sales_need.to_s]
					]
				else
					["", "", "", "", "", "", ""]
				end
			end
			
			pdf.table personal_items, :row_colors => ["FFFFFF", "DDDDDD"] 
			#, :headers => ["Item Cd", "Item Descr", "Quantity", "Price", "Discount", "Discount Reason", "Sales Need"]

			pdf.move_down(20)						
			payments = contract["payment"].map do |key,value| 
				unless value['amount'].blank? 
					[ value[:date.to_s],
						value[:amount.to_s],
						value[:type.to_s], 
						value[:remark.to_s]
					]
				else
					[ "", "","", ""]
				end
			end
			pdf.table payments, :row_colors => ["FFFFFF", "DDDDDD"] 
			#, :headers => ["Down Pymt Dt", "Amount", "Down Pymt_Type", "Remarks"]
			
			pdf.move_down(20)
			images  = contract["file"].map do |key,value| 
				unless value['image_name'].blank? 
					[ value[:image_name.to_s],
					  value[:upload_type.to_s]
					]
				else
					["", ""]
				end
			end

			pdf.table images,:row_colors => ["FFFFFF", "DDDDDD"]
			#, :headers =>  ["Image Name", "Document Type",   "Uploaded File"]
			
			
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
			filename = "#{contract['location_id']}_#{contract['contract_no']}"
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
