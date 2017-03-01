Jm81auth.config do |config|
  config.jwt_secret = Rails.application.secrets.jwt_secret
  config.client_secrets = {
    'github' => Rails.application.secrets.github_oauth_secret
  }
end
