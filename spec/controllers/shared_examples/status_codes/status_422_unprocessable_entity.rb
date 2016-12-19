RSpec.shared_examples '422 - :unprocessable_entity' do
  it 'retornar o status code 422 - :unprocessable_entity' do
    expect(response).to have_http_status(422)
  end
end