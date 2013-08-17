
OmniAuth.config.logger = Rails.logger
FB_APP = YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env]
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FB_APP["app_id"], FB_APP["app_secret"]
end