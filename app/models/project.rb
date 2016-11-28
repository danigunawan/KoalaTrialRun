class Project < ApplicationRecord
  belongs_to :user

  def self.from_omniauth(auth, user)
    Project.where(user: user, email: auth['email']).first_or_initialize.update_attributes!(
      uid: auth['id'],
      oauth_token: auth['oauth_token'],
      user: user
    )
    Project.find_by(email: auth['email'], user: user)
  end
end
