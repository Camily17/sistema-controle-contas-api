require 'rails_helper'

RSpec.describe API::V1::TransacoesController, type: :controller do

  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  let!(:conta_origem) { FactoryGirl.create(:conta_pessoa_fisica, saldo: 0) }
  let!(:codigo_transacional) { TransacaoHelper::Gerador.codigo_alphanumerico(conta_origem_id: conta_origem.id, conta_origem_valor_antes_transacao: conta_origem.saldo, tipo: 'carga')}
  let!(:transacao_carga) { FactoryGirl.create(:transacao_carga, codigo_transacional: codigo_transacional, conta_origem_id: conta_origem.id, conta_origem_valor_antes_transacao: conta_origem.saldo) }
  let(:atributos_validos) { FactoryGirl.attributes_for(:transacao_carga_atributos_validos, conta_origem_id: conta_origem.id) }
  let(:atributos_invalidos) { FactoryGirl.attributes_for(:transacao_carga_atributos_invalidos) }

  describe 'GET #index' do
    it_behaves_like 'GET #index', Transacao do
      let(:parametros) { {} }
      let(:objeto_esperado) { transacao_carga }
    end
  end

  describe 'GET #show' do
    it_behaves_like 'GET #show', Transacao do
      let(:parametros) { { id: transacao_carga.id } }
      let(:objeto_esperado) { transacao_carga }

      let(:parametro_id_invalido) { { id: atributos_invalidos[:id] } }
    end
  end

  describe 'POST #create' do
    it_behaves_like 'POST #create', Transacao do
      let(:parametros_validos) { { transacao: atributos_validos } }

      let(:parametros_invalidos) { { transacao: atributos_invalidos } }
    end

    it 'atualizar saldo da conta origem' do
      expect {
        post :create, body: atributos_validos.to_json
      }.to change(Transacao, :count).by(1)

      expect(conta_origem.reload.saldo).to eq(500)
    end
  end
end
