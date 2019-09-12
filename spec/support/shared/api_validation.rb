shared_examples 'API Validatable' do
  it 'returns success status' do
    do_request(method, api_path, params: valid_params, headers: headers)
    expect(response).to be_successful
  end

  it 'returns unprocessible_entity status' do
    do_request(method, api_path, params: invalid_params, headers: headers)
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
