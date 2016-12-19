require 'rails_helper'

RSpec.describe API::V1::PessoasFisicasController, type: :controller do
  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  let!(:pessoa_fisica) { FactoryGirl.create(:pessoa_fisica) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:pessoa_fisica) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:pessoa_fisica_invalida) }

  describe 'GET #index' do
    before { get :index, params: { format: :json } }

    it 'retornar o status code 200 - :ok' do
      expect(response).to have_http_status(200)
    end

    it 'não aceitar o body vazio' do
      refute_empty response.body
    end

    it 'retornar um array de pessoas_fisicas válida' do
      pessoas_fisicas = symbolizar_json(response.body)

      nomes = pessoas_fisicas.collect { |pf| pf[:nome] }

      assert_includes nomes, pessoa_fisica.nome
    end

    it 'certificar que o Mime type seja JSON' do
      expect(response.content_type).to eq(Mime[:json])
    end
  end

  describe 'GET #show' do
    context 'com o id válido' do
      before { get :show, params: { id: pessoa_fisica.to_param } }

      it 'retornar o status code 200 - :ok' do
        expect(response).to have_http_status(200)
      end

      it 'retorna uma pessoa física válida' do
        pessoa_fisica_response = symbolizar_json(response.body)
        expect(pessoa_fisica_response[:nome]).to eq(pessoa_fisica.nome)
      end

      it 'certificar que o Mime type seja JSON' do
        expect(response.content_type).to eq(Mime[:json])
      end
    end

    context 'com o id inválido' do
      it 'retornar o status code 404 - :not_found' do
        get :show, params: { id: 404 }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #create' do
    context 'com parâmetros válidos' do
      it 'retornar o status code 204 - :no_content' do
        post :create, body: { pessoa_fisica: valid_attributes }.to_json
        expect(response).to have_http_status(204)
      end

      it 'criar uma nova PessoaFisica' do
        expect {
          post :create, body: { pessoa_fisica: valid_attributes }.to_json
        }.to change(PessoaFisica, :count).by(1)
      end
    end

    context 'com parâmetros inválidos' do
      it 'retornar o status code 422 - :unprocessable_entity' do
        post :create, body: { pessoa_fisica: invalid_attributes }.to_json
        expect(response).to have_http_status(422)
      end

      it 'não criar uma nova PessoaFisica' do
        expect {
          post :create, body: { pessoa_fisica: invalid_attributes }.to_json
        }.not_to change(PessoaFisica, :count)
      end

      it 'certificar que o Mime type seja JSON' do
        post :create, body: { pessoa_fisica: invalid_attributes }.to_json
        expect(response.content_type).to eq(Mime[:json])
      end
    end
  end

  describe 'PUT #update' do
    context 'com parâmetros válidos' do
      before { patch :update, params: { id: pessoa_fisica.to_param }, body: { pessoa_fisica: valid_attributes }.to_json }

      it 'retornar o status code 200 - :ok' do
        expect(response).to have_http_status(200)
      end

      it 'atualiar a pessoa_fisica requisitada' do
        pessoa_fisica.reload
        expect(pessoa_fisica.cpf).to eq(valid_attributes[:cpf])
      end

      it 'certificar que o Mime type seja JSON' do
        expect(response.content_type).to eq(Mime[:json])
      end
    end

    context 'com parâmetros inválidos' do
      context 'com o id válido' do
        before { patch :update, params: { id: pessoa_fisica.to_param }, body: { pessoa_fisica: invalid_attributes }.to_json }

        it 'retornar o status code 422 - :unprocessable_entity' do
          expect(response).to have_http_status(422)
        end

        it 'não atualizar a pessoa_fisica requisitada' do
          pessoa_fisica.reload
          expect(pessoa_fisica.cpf).not_to eq(invalid_attributes[:cpf])
        end

        it 'certificar que o Mime type seja JSON' do
          expect(response.content_type).to eq(Mime[:json])
        end
      end


      context 'com o id inválido' do
        it 'retornar o status code 404 - :not_found' do
          patch :update, params: { id: 404 }, body: { pessoa_fisica: invalid_attributes }.to_json
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'com o id válido' do
      it 'deletar a pessoa_fisica requisitada' do
        expect {
          delete :destroy, params: { id: pessoa_fisica.to_param }
        }.to change(PessoaFisica, :count).by(-1)
      end

      it 'retornar o status code 204 - :no_content' do
        delete :destroy, params: { id: pessoa_fisica.to_param }
        expect(response).to have_http_status(204)
      end
    end

    context 'com o id inválido' do
      it 'retornar o status code 404 - :not_found' do
        delete :destroy, params: { id: 404 }
        expect(response).to have_http_status(404)
      end
    end
  end
end
