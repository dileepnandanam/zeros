
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "222243911260028", "95115819d3bfc73e664709725dec0e9f"
end