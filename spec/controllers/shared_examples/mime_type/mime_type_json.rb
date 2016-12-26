RSpec.shared_examples 'mime type JSON' do
  it 'certificar que o Mime type seja JSON' do
    expect(response.content_type).to eq(Mime[:json])
  end
end