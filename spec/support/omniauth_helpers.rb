module OmniauthHelpers
  def mock_auth_hash(provider, _email = nil)
    hash = {
      'provider' => provider.to_s,
      'uid' => '123545'
    }

    hash.merge!('info' => { 'email' => 'mockuser@mail.com' }) if provider == :github

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(hash)
  end
end
