module Services
  class Params
    require 'active_support/all'

    def self.deploy(obj)
      @url_obj = obj
      if obj.instance_of?(ActionController::Parameters)
        return_new_hash @url_obj
      else
        check_for_decode
      end
    end

    def self.check_for_decode
      return_params(decode(@url_obj)) if base64? @url_obj

      return_params @url_obj
    end

    def self.return_new_hash(hash)
      hash[:campaign] = hash.delete(:track)
      campaign = hash[:campaign].split(/=/)
      hash[:campaign] = campaign[1]
      hash
    end

    def self.return_params(str)
      arry = str.split(/&/)
      hash = {}
      raise StandardError 'Not Found' if arry.length <= 1

      arry.each { |a| hash[a.scan(/^\w*/).join('').to_sym] = a.gsub(/^(\w*=)/, '') }
      hash
    end

    def self.decode(str)
      Base64.urlsafe_decode64(str)
    end

    def self.base64?(str)
      str =~ %r{^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==)$}
    end

  end
end
