require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    if resource[:authentication] == :dsa
      OpenSSL::PKey::DSA.new(file, resource[:password])
    elsif resource[:authentication] == :rsa
      OpenSSL::PKey::RSA.new(file, resource[:password])
    elsif resource[:authentication] == :ec
      OpenSSL::PKey::EC.new(file, resource[:password])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def self.check_private_key(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))
    priv = private_key(resource)
    cert.check_private_key(priv)
  end

  def self.old_cert_is_equal(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))

    alt_name = ''
    cert.extensions.each do |ext|
      alt_name = ext.value if ext.oid == 'subjectAltName'
    end

    cdata = {}
    cert.subject.to_s.split('/').each do |name|
      k, v = name.split('=')
      cdata[k] = v
    end

    require 'puppet/util/inifile'
    ini_file = Puppet::Util::IniConfig::PhysicalFile.new(resource[:template])
    if (req_ext = ini_file.get_section('req_ext'))
      if (value = req_ext['subjectAltName'])
        return false if value.delete(' ').gsub(%r{^"|"$}, '') != alt_name.delete(' ').gsub(%r{^"|"$}, '').gsub('IPAddress', 'IP')
      end
    elsif (req_dn = ini_file.get_section('req_distinguished_name'))
      if (value = req_dn['commonName'])
        return false if value != cdata['CN']
      end
    end
    true
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      if resource[:force] && !self.class.check_private_key(resource)
        return false
      end
      unless self.class.old_cert_is_equal(resource)
        return false
      end
      true
    else
      false
    end
  end

  def create
    options = [
      'req',
      '-config', resource[:template],
      '-new', '-x509',
      '-days', resource[:days],
      '-key', resource[:private_key],
      '-out', resource[:path]
    ]
    options << ['-passin', "pass:#{resource[:password]}"] if resource[:password]
    options << ['-extensions', 'req_ext'] if resource[:req_ext] != :false
    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
