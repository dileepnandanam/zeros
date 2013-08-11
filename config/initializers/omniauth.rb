
OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "209241602526454", "550268096a078a253f0b3c303cac5eae"
end