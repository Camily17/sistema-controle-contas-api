class AddAncestryToContas < ActiveRecord::Migration[5.0]
  def change
    add_column :contas, :ancestry, :string, after: :pessoa_id
    add_index :contas, :ancestry
  end
end
