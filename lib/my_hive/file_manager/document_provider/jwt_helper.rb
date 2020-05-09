class JwtHelper
  class << self

    def encode(payload)
      payload = JSON.parse(payload) if payload.is_a?(String)
      payload = {payload: payload}
      header = {alg: "HS256", typ: "JWT" }
      enc_header = Base64.urlsafe_encode64(header.to_json).gsub("=","")
      enc_payload = Base64.urlsafe_encode64(payload.to_json).gsub("=","")
      hash = Base64.urlsafe_encode64(calc_hash(enc_header, enc_payload)).gsub("=","")

      return "#{enc_header}.#{enc_payload}.#{hash}"
    end

    def decode(token)
      split = token.split(".")
      hash = Base64.urlsafe_encode64(calc_hash(split[0], split[1])).gsub("=","")
      if !hash.eql?(split[2])
        return ""
      end

      return Base64.urlsafe_decode64(split[1])
    end

    private

    def calc_hash(header, payload)
      return OpenSSL::HMAC.digest("SHA256", "secretkey", "#{header}.#{payload}")
    end
  end
end