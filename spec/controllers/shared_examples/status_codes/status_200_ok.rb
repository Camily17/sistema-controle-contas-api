RSpec.shared_examples '200 - :ok' do
  it 'retornar o status code 200 - :ok' do
    expect(response).to have_http_status(200)
  end
end