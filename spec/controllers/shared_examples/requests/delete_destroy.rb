RSpec.shared_examples 'DELETE #destroy' do |klass|
  context 'com o id válido' do
    it "deletar o objeto #{klass.to_s.underscore} requisitado" do
      expect {
        delete :destroy, params: { id: parametro_id_valido }
      }.to change(klass, :count).by(-1)
    end

    context 'retornar status code esperado' do
      before { delete :destroy, params: { id: parametro_id_valido } }

      it_behaves_like '204 - :no_content'
    end
  end

  context 'com o id inválido' do
    context 'retornar status code esperado' do
      before { delete :destroy, params: { id: parametro_id_invalido } }

      it_behaves_like '404 - :not_found'
    end
  end
end