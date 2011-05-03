class MailQueue 
  @queue = :mail_serve

  def self.perform(contract_id, user_id)
    contract = ActiveRecord::Base::Contract.find(contract_id)
    user = ActiveRecord::Base::User.find(user_id)
    ContractMailer.contract_entry_mail(user, contract).deliver
  end
end
