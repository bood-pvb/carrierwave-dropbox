# encoding: utf-8
require "dropbox-api"

module CarrierWave
  module Storage
    class Dropboks < Abstract

      # Stubs we must implement to create and save
      # files (here on Dropbox)

      # Store a single file
      def store!(file)
        location = uploader.store_path
        dropbox_client.upload(location, file.read)

      end

      # Retrieve a single file
      def retrieve!(file)
        CarrierWave::Storage::Dropboks::File.new(uploader, config, uploader.store_path(file), dropbox_client)
      end

      def dropbox_client
        @dropbox_client ||= Dropbox::API::Client.new(token: config[:access_token], secret: config[:access_token_secret])
      end

      private

      def config
        @config ||= {}

        @config[:app_key] ||= uploader.dropbox_app_key
        @config[:app_secret] ||= uploader.dropbox_app_secret
        @config[:access_token] ||= uploader.dropbox_access_token
        @config[:access_token_secret] ||= uploader.dropbox_access_token_secret
        @config[:access_type] ||= uploader.dropbox_access_type || "sandbox"

        @config
      end

      class File
        include CarrierWave::Utilities::Uri
        attr_reader :path

        def initialize(uploader, config, path, client)
          @uploader, @config, @path, @client = uploader, config, path, client
        end

        def url
		  begin
            @client.find(@path).direct_url.url
          rescue Exception => ex
		    "/404"
          end
        end

        def delete
          path = @path
          path = "/#{path}" if @config[:access_type] == "sandbox"
          begin
            @client.find(@path).destroy
          rescue DropboxError
          end
        end
      end
    end
  end
end
