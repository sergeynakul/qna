class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def instagram
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    session[:provider] = auth.provider if auth
    session[:uid] = auth.uid if auth

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Instagram') if is_navigational_format?
    else
      render 'oauth_callbacks/add_email'
    end
  end

  def insta_reg
    auth = OmniAuth::AuthHash.new(params['auth_hash']).merge(provider: session[:provider], uid: session[:uid])
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Instagram') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
