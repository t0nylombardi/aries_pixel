module Services
  class Locations
    require 'net/http'

    ACCESS_KEY = 'ada2431f8e2c8b9ccc8272e57abd9f62'

    def self.lookup(ip_address)
      ip_address = random_ip_address unless Rails.env.production?
      url = "http://api.ipstack.com/#{ip_address}/?access_key=#{ACCESS_KEY}"

      begin
        HTTParty.get(url, timeout: 2)
      rescue Timeout::Error
        Rails.logger.warn("Could not post to #{url}: timeout")
        { city: nil, region_name: nil }
      end
    end

    def self.check_for_local(ip)
      if ['127.0.0.1', '::1'].include? ip
        '108.41.23.150'
      else
        ip
      end
    end

    # These are fake IPS. Put real physical IPS when
    # testing in developement enviorment.
    def self.random_ip_address
      %w[ 127.19.209.10
          127.21.23.150
          127.31.23.155
          127.41.23.170
          127.59.209.14
          127.69.209.80 ].sample
    end

  end
end