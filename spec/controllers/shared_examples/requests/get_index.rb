RSpec.shared_examples 'GET #index' do |klass, inheritance_klass|

  before { get :index, params: parametros }

  it "retornar um array de #{klass.to_s.underscore.pluralize} válido" do
    expect(assigns(klass.to_s.underscore.pluralize.to_sym).count).to eq(numero_registros)
    expect(assigns(klass.to_s.underscore.pluralize.to_sym)).to include(objeto_esperado)
  end

  it 'não aceitar o body vazio' do
    refute_empty response.body
  end

  context 'retornar mime type esperado' do
    it_behaves_like 'mime type JSON'
  end

  context 'retornar status code esperado' do
    it_behaves_like '200 - :ok'
  end
end