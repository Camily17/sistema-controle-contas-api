RSpec.shared_examples 'POST #create' do |klass|

  context 'com parâmetros válidos' do
    it "criar um objeto #{klass}" do
      expect {
        post :create, body: parametros_validos.to_json
      }.to change(klass, :count).by(1)
    end

    context 'retornar status code esperado' do
      before { post :create, body: parametros_validos.to_json }

      it_behaves_like '204 - :no_content'
    end
  end

  context 'com parâmetros inválidos' do
    it 'não criar uma nova PessoaFisica' do
      expect {
        post :create, body: parametros_invalidos.to_json
      }.not_to change(klass, :count)
    end

    context 'retornar status code esperado' do
      before { post :create, body: parametros_invalidos.to_json }

      it_behaves_like '422 - :unprocessable_entity'
    end

    context 'retornar mime type esperado' do
      before { post :create, body: parametros_invalidos.to_json }

      it_behaves_like 'mime type JSON'
    end
  end
end