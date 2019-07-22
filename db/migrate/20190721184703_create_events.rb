class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :operation
      t.float :value
      t.float :balance, default: 0
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
