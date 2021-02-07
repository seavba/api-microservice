require 'pathname'
Puppet::Type.newtype(:dhparam) do
  desc 'A Diffie Helman parameter file'

  ensurable

  newparam(:path, namevar: true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:size) do
    desc 'The key size'
    newvalues %r{\d+}
    defaultto 512
    validate do |value|
      size = value.to_i
      if size <= 0 || value.to_s != size.to_s
        raise ArgumentError, "Size must be a positive integer: #{value.inspect}"
      end
    end
  end

  newparam(:fastmode) do
    desc 'Enable fast mode'
    defaultto false
    validate do |value|
      if !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
        raise ArgumentError, "Fastmode must be a boolean: #{value.inspect} #{value.class}"
      end
    end
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end
end
