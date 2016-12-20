class CreateContas < ActiveRecord::Migration[5.0]
  def change
    create_table :contas do |t|
      t.string :nome, null: false, unique: true, limit: 70
      t.decimal :saldo, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.belongs_to :pessoa, polymorphic: true

      t.timestamps
    end

    add_index 'contas', [:nome], name: 'index_nome_unique', unique: true
    add_index 'contas', [:pessoa_id, :pessoa_type]
  end
end
