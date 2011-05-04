class ContractMailer < ActionMailer::Base
  default :from => "bookglam@gmail.com"
  
  def contract_entry_mail(user, contract)
    @user = user
    @contract = contract
    attachments["#{contract.location_id}_#{contract.contract_no}.zip"] = File.read("#{Rails.root}/files/compress/#{contract.location_id}_#{contract.contract_no}.zip")
    mail(:to => "#{user.email}", :subject => "Contract Entry Saved", :body => "Thanks for making a Contract Entry! Please find the zipped attachment file.")
  end
end
