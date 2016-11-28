Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], :scope => ENV['FACEBOOK_SCOPE'], auth_type: 'reauthenticate'
end
