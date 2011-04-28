require 'prawn'
require "prawn/measurement_extensions"


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
end
