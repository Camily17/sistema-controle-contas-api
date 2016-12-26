require 'rails_helper'

RSpec.describe Transacao, type: :model do
  before(:all) { DatabaseCleaner.clean_with(:deletion) }

  let!(:conta_origem) { FactoryGirl.create(:conta_pessoa_fisica, saldo: 0) }
  let!(:codigo_transacional) { TransacaoHelper::Gerador.codigo_alphanumerico(conta_origem_id: conta_origem.id, conta_origem_valor_antes_transacao: conta_origem.saldo, tipo: 'carga')}
  let!(:transacao_carga) { FactoryGirl.create(:transacao_carga, codigo_transacional: codigo_transacional, conta_origem_id: conta_origem.id, conta_origem_valor_antes_transacao: conta_origem.saldo) }

  describe 'Validações' do
    context ':codigo_transacional' do
      it 'deve estar presente' do should validate_presence_of(:codigo_transacional) end
      it 'deve ser único' do should validate_uniqueness_of(:codigo_transacional) end
      it 'deve ter 32 caracteres' do should validate_length_of(:codigo_transacional).is_equal_to(32) end
    end

    context ':tipo' do
      it 'deve ser único' do should validate_presence_of(:codigo_transacional) end
      it 'deve ter tipo válido' do should define_enum_for(:tipo).with([:carga, :transferencia, :estorno]) end
    end

    context ':valor' do
      it 'deve estar presente' do should validate_presence_of(:valor) end
      it 'deve ser numérico' do should validate_numericality_of(:valor).is_greater_than(0) end
    end

    context ':conta_origem_id' do
      it 'deve estar presente' do should validate_presence_of(:conta_origem_id) end
      it 'deve ser numérico e inteiro' do should validate_numericality_of(:conta_origem_id).only_integer end
    end

    context ':conta_origem_valor_antes_transacao' do
      it 'deve estar presente' do should validate_presence_of(:conta_origem_valor_antes_transacao) end
      it 'deve ser numérico' do should validate_numericality_of(:conta_origem_valor_antes_transacao) end
    end

    context ':conta_destino_id' do
      it 'deve ser numérico e inteiro' do should validate_numericality_of(:conta_destino_id).only_integer end
      it 'deve permitir nulo' do should allow_value(nil).for(:conta_destino_id) end
    end

    context ':conta_destino_valor_antes_transacao' do
      it 'deve ser numérico' do should validate_numericality_of(:conta_origem_id).only_integer end
      it 'deve permitir nulo' do should allow_value(nil).for(:conta_destino_valor_antes_transacao) end
    end

    context ':codigo_transacional_estornado' do
      it 'deve ser unico' do should validate_uniqueness_of(:codigo_transacional_estornado) end
      it 'deve ter 32 caracteres' do should validate_length_of(:codigo_transacional_estornado).is_equal_to(32) end
      it 'deve permitir nulo' do should allow_value(nil).for(:codigo_transacional_estornado) end
    end
  end

  describe 'Associações' do
    it 'deve ter associação com conta através de conta_origem' do should belong_to(:conta_origem).class_name('Conta').with_foreign_key(:conta_origem_id) end
    it 'deve ter associação com conta através de conta_destino' do should belong_to(:conta_destino).class_name('Conta').with_foreign_key(:conta_destino_id) end
  end
end
