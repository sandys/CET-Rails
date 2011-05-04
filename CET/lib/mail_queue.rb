class MailQueue 
  @queue = :mail_serve

  def self.perform(contract_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    user = ActiveRecord::Base::User.find(contract.user_id)
    ContractMailer.contract_entry_mail(user, contract).deliver
  end
end
