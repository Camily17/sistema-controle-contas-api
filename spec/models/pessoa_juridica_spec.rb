require 'rails_helper'

RSpec.describe PessoaJuridica, type: :model do
  let!(:pessoa_juridica) { FactoryGirl.create(:pessoa_juridica) }

  describe 'Validações' do
    context ':cnpj' do
      it 'deve estar presente' do should validate_presence_of(:cnpj) end
      it 'deve ser único' do should validate_uniqueness_of(:cnpj).case_insensitive end
      it 'deve ser numérico' do should validate_numericality_of(:cnpj).only_integer end
      it 'deve ter 14 caracteres' do should validate_length_of(:cnpj).is_equal_to(14) end
    end

    context ':razao_social' do
      it 'deve estar presente' do should validate_presence_of(:razao_social) end
      it 'deve ser único' do should validate_uniqueness_of(:razao_social) end
      it 'deve ter entre 2 e 70 caracteres' do should validate_length_of(:razao_social).is_at_least(2).is_at_most(70) end
    end

    context ':nome_fantasia' do
      it 'deve estar presente' do should validate_presence_of(:nome_fantasia) end
      it 'deve ser único' do should validate_uniqueness_of(:nome_fantasia) end
      it 'deve ter entre 2 e 70 caracteres' do should validate_length_of(:nome_fantasia).is_at_least(2).is_at_most(70) end
    end
  end

end
