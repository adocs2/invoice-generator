class CreateInvoice < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :number
      t.date :date
      t.text :company
      t.text :billing_to
      t.decimal :total_amount, precision: 10, scale: 2
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :invoices, [:user_id, :number], unique: true
  end
end
