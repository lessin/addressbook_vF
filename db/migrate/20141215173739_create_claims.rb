class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.integer :subject_uid, :limit => 8
      t.string :subject
      t.string :verb
      t.string :object
      t.string :author

      t.timestamps
    end
  end
end

