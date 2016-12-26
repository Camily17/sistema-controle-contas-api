RSpec.shared_examples '404 - :not_found' do
  it 'retornar o status code 404 - :not_found' do
    expect(response).to have_http_status(404)
  end
end