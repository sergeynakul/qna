shared_examples 'API Lists' do
  it 'returns status 200' do
    expect(response).to be_successful
  end

  it 'returns list of files' do
    expect(resource_response['files'].size).to eq resource.files.size
  end

  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq resource.comments.size
  end

  it 'returns list of links' do
    expect(resource_response['links'].size).to eq resource.links.size
  end
end
