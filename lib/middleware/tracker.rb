module Middleware
  class Tracker

    def initialize(app)
      @app = app
    end

    def call(env)
      @req = ::Rack::Request.new(env)
      result = Services::Params.deploy @req.query_string
      location = Services::Locations.lookup(@req.ip)
      if @req.path_info =~ /tracker.gif/
        params = {
          ip_address: location['ip'] || @req.ip,
          campaign: result[:campaign],
          banner_size: result[:banner_size],
          content_type: result[:content_type],
          city: location['city'],
          state: location['region_name'],
          user_agent: @req.user_agent,
          referral: @req.referer
        }

        if Pixel.create!(params)
          [200, { 'Content-Type' => 'image/gif' }, [File.read(File.join(File.dirname(__FILE__), 'tracker.gif'))]]
        else
          Rails.logger.warn "\n\n Failed to create record on:#{Date.today}"
        end
      else
        @app.call(env)
      end
    end

  end
end
