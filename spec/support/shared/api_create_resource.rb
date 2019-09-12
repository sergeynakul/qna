shared_examples 'API create resource' do
  context 'authorized' do
    context 'with valid params' do
      it 'create the resource' do
        expect { post api_path, params: valid_params, headers: headers }.to change(resource, :count).by(1)
      end

      it 'returns success status' do
        post api_path, params: valid_params, headers: headers
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'do not create the resource' do
        expect { post api_path, params: invalid_params, headers: headers }.to_not change(resource, :count)
      end

      it 'returns unprocessible_entity status' do
        post api_path, params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
