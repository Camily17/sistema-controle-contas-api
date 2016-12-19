class CreatePessoasJuridicas < ActiveRecord::Migration[5.0]
  def change
    create_table :pessoas_juridicas do |t|
      t.string :cnpj, null: false, unique: true, limit: 14
      t.string :razao_social, null: false, unique: true, limit: 70
      t.string :nome_fantasia, null: false, unique: true, limit: 70

      t.timestamps
    end

    add_index 'pessoas_juridicas', [:cnpj], name: 'index_cnpj_unique', unique: true
    add_index 'pessoas_juridicas', [:razao_social], name: 'index_razao_social_unique', unique: true
    add_index 'pessoas_juridicas', [:nome_fantasia], name: 'index_nome_fantasia_unique', unique: true
  end
end
