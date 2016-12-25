require 'rails_helper'

RSpec.describe API::V1::PessoasFisicasController, type: :controller do
  before(:all) { DatabaseCleaner.clean_with(:deletion) }
  after(:all) { DatabaseCleaner.clean_with(:deletion) }

  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  let!(:pessoa_fisica) { FactoryGirl.create(:pessoa_fisica) }
  let(:atributos_validos) { FactoryGirl.attributes_for(:pessoa_fisica) }
  let(:atributos_invalidos) { FactoryGirl.attributes_for(:pessoa_fisica_invalida) }

  describe 'GET #index' do
    it_behaves_like 'GET #index', PessoaFisica do
      let(:parametros) { {} }
      let(:objeto_esperado) { pessoa_fisica }
      let(:numero_registros) { 1 }
    end
  end

  describe 'GET #show' do
    it_behaves_like 'GET #show', PessoaFisica do
      let(:parametros) { { id: pessoa_fisica.id } }
      let(:objeto_esperado) { pessoa_fisica }

      let(:parametro_id_invalido) { { id: atributos_invalidos[:id] } }
    end
  end

  describe 'POST #create' do
    it_behaves_like 'POST #create', PessoaFisica do
      let(:parametros_validos) { { pessoa_fisica: atributos_validos } }

      let(:parametros_invalidos) { { pessoa_fisica: atributos_invalidos } }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update', PessoaFisica do
      let(:objeto_esperado) { pessoa_fisica }
      let(:objeto_esperado_atributo) { pessoa_fisica.nome }

      let(:parametros_validos) { { pessoa_fisica: atributos_validos } }
      let(:parametro_id_valido) { pessoa_fisica.id }
      let(:atributo_atualizado_valido) { atributos_validos[:nome] }

      let(:parametros_invalidos) { { pessoa_fisica: atributos_invalidos } }
      let(:atributo_atualizado_invalido) { atributos_invalidos[:nome] }
      let(:parametro_id_invalido) { atributos_invalidos[:id] }
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'DELETE #destroy', PessoaFisica do
      let(:parametro_id_valido) { pessoa_fisica.id }
      let(:parametro_id_invalido) { atributos_invalidos[:id] }
    end
  end
end
