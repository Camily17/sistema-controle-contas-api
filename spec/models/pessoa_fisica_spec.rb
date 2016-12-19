require 'rails_helper'

RSpec.describe PessoaFisica, type: :model do
  let!(:pessoa_fisica) { FactoryGirl.create(:pessoa_fisica) }

  describe 'Validações' do
    context ':cpf' do
      it 'deve estar presente' do should validate_presence_of(:cpf) end
      it 'deve ser único' do should validate_uniqueness_of(:cpf).case_insensitive end
      it 'deve ser numérico e inteiro' do should validate_numericality_of(:cpf).only_integer end
      it 'deve ter 11 caracteres' do should validate_length_of(:cpf).is_equal_to(11) end
    end

    context ':nome' do
      it 'deve estar presente' do should validate_presence_of(:nome) end
      it 'deve ser letras' do should allow_value('Pedro dos Santos Pereira').for(:nome) end
      it 'não deve conter números ou caracteres especiais' do should_not allow_value('Pedro 5 Com 80% Normal').for(:nome) end
      it 'deve ter entre 2 e 70 caracteres' do should validate_length_of(:nome).is_at_least(2).is_at_most(70) end
    end

    context ':data_nascimento' do
      let!(:valid_date) { DateTime.now.to_date }
      let!(:invalid_date) { DateTime.now.to_date + 1.day }

      it 'deve estar presente' do should validate_presence_of(:data_nascimento) end
      it 'deve ter um formato de data' do should allow_value('2016-10-01').for(:data_nascimento) end
      it 'não deve ter um formato diferente de data' do should_not allow_value('AA-dd-15').for(:data_nascimento) end

      it 'deve ser uma data válida' do should allow_value(valid_date).for(:data_nascimento) end
      it 'não deve ser uma data futura' do should_not allow_value(invalid_date).for(:data_nascimento) end
    end
  end
end
