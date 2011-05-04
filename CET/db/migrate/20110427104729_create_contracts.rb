class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.integer :user_id
      t.integer :contract_no
      t.integer :location_id
      t.text :data
      t.timestamps
    end
  end

  def self.down
    drop_table :contracts
  end
end
