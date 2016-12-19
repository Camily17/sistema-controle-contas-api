class CreatePessoasFisicas < ActiveRecord::Migration[5.0]
  def change
    create_table :pessoas_fisicas do |t|
      t.string :cpf, null: false, unique: true, limit: 11
      t.string :nome, null: false, limit: 70
      t.date :data_nascimento, null: false

      t.timestamps
    end

    add_index 'pessoas_fisicas', [:cpf], name: 'index_cpf_unique', unique: true
  end
end
