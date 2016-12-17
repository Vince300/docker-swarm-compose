require "uri"

module URI
  class UNIX < Generic
    alias_method :orig_path, :path

    def hostname
      'localhost'
    end

    def socket_path
      parsed_orig_path[0]
    end

    def path
      parsed_orig_path[1] || ''
    end

    # So it behaves like URI::HTTP
    def request_uri
      r = if query
        path + '?' + query
      else
        path
      end
    end

    def to_s
      "unix://" + socket_path + if request_uri then ':' + request_uri else '' end
    end

    private
    def parsed_orig_path
      orig_path.split(':', 2)
    end
  end

  @@schemes['UNIX'] = UNIX
end