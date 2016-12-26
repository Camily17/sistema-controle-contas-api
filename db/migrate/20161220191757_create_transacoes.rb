class CreateTransacoes < ActiveRecord::Migration[5.0]
  def change
    create_table :transacoes do |t|
      t.string :codigo_transacional, null: false, unique: true
      t.integer :tipo, null: false
      t.decimal :valor, null: false
      t.belongs_to :conta_origem, as: :contas, null: false, index: true
      t.decimal :conta_origem_valor_antes_transacao, null: false
      t.belongs_to :conta_destino, as: :contas, index: true
      t.decimal :conta_destino_valor_antes_transacao
      t.boolean :estornado, null: false, default: 0
      t.string :codigo_transacional_estornado, unique: true

      t.timestamps
    end

    add_index :transacoes, [:codigo_transacional], name: 'index_codigo_transacional_unique', unique: true
    add_index :transacoes, [:codigo_transacional_estornado], name: 'index_codigo_transacional_estornado_unique', unique: true
  end
end
