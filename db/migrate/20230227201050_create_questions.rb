class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :name
      t.string :tipo_pergunta
      #t.references :formulary, null: false, foreign_key: true
      t.references :formulary, index: true, foreign_key: true

      t.timestamps
    end
  end
end
