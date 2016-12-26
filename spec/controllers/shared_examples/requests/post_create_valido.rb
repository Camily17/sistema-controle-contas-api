RSpec.shared_examples 'POST #create válido' do |klass|

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
end