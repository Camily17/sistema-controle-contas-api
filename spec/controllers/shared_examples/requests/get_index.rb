RSpec.shared_examples 'GET #index' do |klass|

  before { get :index, params: parametros }

  it "retornar um array de #{klass.to_s.underscore.pluralize} válido" do
    expect(assigns(klass.to_s.underscore.pluralize.to_sym)).to eq([objeto_esperado])
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