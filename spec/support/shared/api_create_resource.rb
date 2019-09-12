shared_examples 'API create resource' do
  context 'authorized' do
    it 'with valid params create the resource' do
      expect { post api_path, params: valid_params, headers: headers }.to change(resource, :count).by(1)
    end

    it 'with invalid params do not create the resource' do
      expect { post api_path, params: invalid_params, headers: headers }.to_not change(resource, :count)
    end
  end
end
