class CreateCertificates < ActiveRecord::Migration
  def self.up
    create_table :certificates do |t|
      t.string :subject
      t.string :issuer
      t.integer :serial
      t.integer :version
      t.string :signature_algorithm
      t.datetime :not_before
      t.datetime :not_after

      t.timestamps
    end
  end

  def self.down
    drop_table :certificates
  end
end
