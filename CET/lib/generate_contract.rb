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
			pdf.render_file(Rails.root.join('files/pdf',"#{contract.id}_#{contract.name}.pdf"))
		end
	end
	
	
	class XLS
		def self.create(contract)
			book = Spreadsheet::Workbook.new
			sheet = book.create_worksheet :name => "data"
			sheet.row(0).concat %w{Name Phone}
			sheet.row(1).push contract.name, contract.phone
			book.write(Rails.root.join('files/xls',"#{contract.id}_#{contract.name}.xls"))
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
