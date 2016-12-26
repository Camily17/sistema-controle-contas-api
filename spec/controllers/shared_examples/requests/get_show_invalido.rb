RSpec.shared_examples 'GET #show inválid' do
  context 'com o id inválido' do
    context 'retornar status code esperado' do
      before { get :show, params: { id: parametro_id_invalido } }

      it_behaves_like '404 - :not_found'
    end
  end
end