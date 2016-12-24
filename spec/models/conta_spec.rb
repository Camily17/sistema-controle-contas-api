require 'rails_helper'

RSpec.describe Conta, type: :model do
  before(:all) { DatabaseCleaner.clean_with(:deletion) }

  let!(:contas) { FactoryGirl.create(:conta_pessoa_fisica) }

  describe 'Validações' do
    context ':nome' do
      it 'deve estar presente' do should validate_presence_of(:nome) end
      it 'deve ser letras' do should allow_value('Nome da Conta').for(:nome) end
      it 'não deve conter números ou caracteres especiais' do should_not allow_value('Nome da conta 5 com 80% Normal').for(:nome) end
      it 'deve ter entre 2 e 70 caracteres' do should validate_length_of(:nome).is_at_least(2).is_at_most(70) end
    end

    context ':saldo' do
      it 'deve estar presente' do should validate_presence_of(:saldo) end
      it 'deve ser numérico' do should validate_numericality_of(:saldo) end
    end

    context ':status' do

      it 'deve estar presente' do should validate_presence_of(:status) end
      it 'deve ter um status válido' do should define_enum_for(:status).with(['cancelado', 'ativo', 'bloqueado']) end
    end

    context ':pessoa_type' do
      it 'deve estar presente' do should validate_presence_of(:pessoa_type) end
    end

    context ':pessoa_id' do
      it 'deve estar presente' do should validate_presence_of(:pessoa_id) end
    end
  end

  describe 'Associações' do
    it 'deve ter associação polimórfica com pessoa' do should belong_to(:pessoa) end
  end
end
