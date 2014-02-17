require 'carrierwave'
require 'carrierwave/storage/dropbox'

class CarrierWave::Uploader::Base
  add_config :dropbox_app_key
  add_config :dropbox_app_secret
  add_config :dropbox_access_token
  add_config :dropbox_access_token_secret
  add_config :dropbox_access_type

  configure do |config|
    config.storage_engines[:dropbox] = 'CarrierWave::Storage::Dropboks'
  end
end
