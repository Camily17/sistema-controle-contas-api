RSpec.shared_examples 'GET #show válido' do |klass|

  context 'com o id válido' do
    before { get :show, params: parametros }

    it "retorna uma instância de #{klass.to_s.underscore} válida" do
      expect(assigns(klass.to_s.underscore.to_sym)).to eq(objeto_esperado)
    end

    context 'retornar mime type esperado' do
      it_behaves_like 'mime type JSON'
    end

    context 'retornar status code esperado' do
      it_behaves_like '200 - :ok'
    end
  end
end