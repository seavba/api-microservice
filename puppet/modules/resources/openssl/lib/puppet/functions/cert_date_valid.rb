# @summary
#
#   Checks SSL cetificate date validity.
#
# Parameter: path to ssl certificate
#
Puppet::Functions.create_function(:cert_date_valid) do
  # @param certfile The certificate file to check.
  #
  # @return false if the certificate is expired or not yet valid,
  # or the number of seconds the certificate is still valid for.
  #
  dispatch :valid? do
    repeated_param 'String', :certfile
  end

  def valid?(certfile)
    require 'time'
    require 'openssl'

    content = File.read(certfile)
    cert = OpenSSL::X509::Certificate.new(content)

    if cert.not_before.nil? && cert.not_after.nil?
      raise 'No date found in certificate'
    end

    now = Time.now

    if now > cert.not_after
      # certificate is expired
      false
    elsif now < cert.not_before
      # certificate is not yet valid
      false
    elsif cert.not_after <= cert.not_before
      # certificate will never be valid
      false
    else
      # return number of seconds certificate is still valid for
      (cert.not_after - now).to_i
    end
  end
end
