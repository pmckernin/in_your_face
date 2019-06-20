Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit, ENV.fetch("O_AUTH_ID"), ENV.fetch("FITBIT_SECRET"), scope: "activity profile weight"
end