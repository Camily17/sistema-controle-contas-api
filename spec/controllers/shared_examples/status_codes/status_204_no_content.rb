RSpec.shared_examples '204 - :no_content' do
  it 'retornar o status code 204 - :no_content' do
    expect(response).to have_http_status(204)
  end
end