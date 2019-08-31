module OmniauthHelpers
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '123545',
      'info' => {
        'email' => 'mockuser@mail.com'
      }
    )
  end

  def mock_auth_hash_without_mail
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'instagram',
      'uid' => '123545'
    )
  end
end
