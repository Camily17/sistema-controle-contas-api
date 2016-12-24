require 'rails_helper'

RSpec.describe API::V1::PessoasJuridicasController, type: :controller do
  before(:all) { DatabaseCleaner.clean_with(:deletion) }
  after(:all) { DatabaseCleaner.clean_with(:deletion) }

  before(:each) do
    DatabaseCleaner.strategy = :deletion
  end

  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  let!(:pessoa_juridica) { FactoryGirl.create(:pessoa_juridica) }
  let(:atributos_validos) { FactoryGirl.attributes_for(:pessoa_juridica) }
  let(:atributos_invalidos) { FactoryGirl.attributes_for(:pessoa_juridica_invalida) }

  describe 'GET #index' do
    it_behaves_like 'GET #index', PessoaJuridica do
      let(:parametros) { {} }
      let(:objeto_esperado) { pessoa_juridica }
    end
  end

  describe 'GET #show' do
    it_behaves_like 'GET #show', PessoaJuridica do
      let(:parametros) { { id: pessoa_juridica.id } }
      let(:objeto_esperado) { pessoa_juridica }

      let(:parametro_id_invalido) { { id: atributos_invalidos[:id] } }
    end
  end

  describe 'POST #create' do
    it_behaves_like 'POST #create', PessoaJuridica do
      let(:parametros_validos) { { pessoa_juridica: atributos_validos } }

      let(:parametros_invalidos) { { pessoa_juridica: atributos_invalidos } }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'PATCH #update', PessoaJuridica do
      let(:objeto_esperado) { pessoa_juridica }
      let(:objeto_esperado_atributo) { pessoa_juridica.razao_social }

      let(:parametros_validos) { { pessoa_juridica: atributos_validos } }
      let(:parametro_id_valido) { pessoa_juridica.id }
      let(:atributo_atualizado_valido) { atributos_validos[:razao_social] }

      let(:parametros_invalidos) { { pessoa_juridica: atributos_invalidos } }
      let(:atributo_atualizado_invalido) { atributos_invalidos[:razao_social] }
      let(:parametro_id_invalido) { atributos_invalidos[:id] }
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'DELETE #destroy', PessoaJuridica do
      let(:parametro_id_valido) { pessoa_juridica.id }
      let(:parametro_id_invalido) { atributos_invalidos[:id] }
    end
  end
end
