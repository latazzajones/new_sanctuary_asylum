class FriendsController < ApplicationController
  before_action :authenticate_user!
  # TODO ⬇️ this should be moved into the policy
  before_action :require_access_to_community

  after_action :verify_authorized, only: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @friends = policy_scope(Friend)
    authorize @friends
  end

  def show
    if current_user.remote_clinic_lawyer? 
      return not_found unless current_user.existing_remote_relationship?(params[:id])
      if !release && !friend.region.border?
        redirect_to new_remote_clinic_friend_release_path(friend)
      else
        render
      end
    else
      not_found unless UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?
      friend                      
      @current_tab = current_tab  
    end
  end

  def update
    not_found unless UserFriendAssociation.where(friend_id: params[:id], user_id: current_user.id).present?

    friend.update(friend_params)
    respond_to do |format|
      format.js { render file: 'friends/access', locals: { friend: friend } }
    end
  end

  private

  def friend
    @friend ||= current_user.friends.find(params[:id])
  end

  def friend_params
    params.require(:friend).permit(
      user_ids: []
    )
  end

  def current_tab
    if params[:tab].present?
      params[:tab]
    else
      '#basic'
    end
  end

  def release 
    @release ||= current_user.releases.find_by(friend: friend)
  end
end
