class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Reward
    @user = User.find(params[:user_id])
    @rewards = @user.rewards
  end
end
