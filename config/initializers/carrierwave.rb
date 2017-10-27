if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key
    }
    config.fog_directory  = 'monotto-images'
    config.fog_public     = false
    config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" }
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
