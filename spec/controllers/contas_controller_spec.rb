require 'rails_helper'

RSpec.describe API::V1::ContasController, type: :controller do
  before(:all) { DatabaseCleaner.clean_with(:deletion) }
  after(:all) { DatabaseCleaner.clean_with(:deletion) }

  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  let!(:conta) { FactoryGirl.create(:conta_pessoa_fisica) }
  let(:atributos_validos) { FactoryGirl.attributes_for(:conta_pessoa_fisica) }
  let(:atributos_invalidos) { FactoryGirl.attributes_for(:conta_invalida_pessoa_fisica) }

  describe 'GET #index' do
    it_behaves_like 'GET #index', Conta do
      let(:parametros) { {} }
      let(:objeto_esperado) { conta }
      let(:numero_registros) { 1 }
    end
  end

  describe 'GET #show' do
    it_behaves_like 'GET #show', Conta do
      let(:parametros) { { id: conta.id } }
      let(:objeto_esperado) { conta }

      let(:parametro_id_invalido) { { id: atributos_invalidos[:id] } }
    end
  end

  describe 'POST #create' do
    it_behaves_like 'POST #create', Conta do
      let(:parametros_validos) { { conta: atributos_validos } }

      let(:parametros_invalidos) { { conta: atributos_invalidos } }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update', Conta do
      let(:objeto_esperado) { conta }
      let(:objeto_esperado_atributo) { conta.nome }

      let(:parametros_validos) { { conta: atributos_validos } }
      let(:parametro_id_valido) { conta.id }
      let(:atributo_atualizado_valido) { atributos_validos[:nome] }

      let(:parametros_invalidos) { { conta: atributos_invalidos } }
      let(:atributo_atualizado_invalido) { atributos_invalidos[:nome] }
      let(:parametro_id_invalido) { atributos_invalidos[:id] }
    end
  end

  describe 'DELETE #destroy' do
    context 'com o id válido' do
      before { delete :destroy, params: { id: conta.id } }

      it 'alterar o status da conta para cancelado' do
        expect(conta.reload.status).to eq('cancelado')
      end

      context 'retornar status code esperado' do
        it_behaves_like '204 - :no_content'
      end
    end

    context 'com o id inválido' do
      before { delete :destroy, params: { id: atributos_invalidos[:id] } }

      context 'retornar status code esperado' do
        it_behaves_like '404 - :not_found'
      end
    end
  end
end