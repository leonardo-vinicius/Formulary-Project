class CreateFormularies < ActiveRecord::Migration[7.0]
  def change
    create_table :formularies do |t|
      t.string :name
      t.references :visit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
