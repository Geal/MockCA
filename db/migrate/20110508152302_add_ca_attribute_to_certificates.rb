class AddCaAttributeToCertificates < ActiveRecord::Migration
  def self.up
    add_column :certificates, :ca, :boolean, :default => false
  end

  def self.down
    remove_column :certificates, :ca
  end
end
