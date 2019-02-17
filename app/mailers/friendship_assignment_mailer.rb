class FriendshipAssignmentMailer < ApplicationMailer
  def send_assignment_email(user, friend)
    @friend = friend
    @link_url = friend_url(friend)
    mail(to: user.email, subject: 'Friend assignment')
  end
end
