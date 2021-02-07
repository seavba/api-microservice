Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-7"
  # Official CentOS 7 image - latest
  config.vm.box_url = "http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7.box"
#Install puppet, puppet-agent, hiera gems, ruby on the VM
  config.vm.provision "shell", inline: "sudo rpm -q puppetlabs-release-pc1 &>/dev/null || sudo yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm"
  config.vm.provision "shell", inline: "sudo yum install puppet-agent vim ruby -y"
  config.vm.provision "shell",
    inline: "gem install hiera-eyaml ; /opt/puppetlabs/puppet/bin/gem install hiera-eyaml"
  config.vm.provision "shell", inline: "sudo yum -y update kernel*"
#VM definition
  config.vm.define(:puppet) { |puppet|
    puppet.vm.host_name = "api-ms-01"
    config.vm.network "private_network", ip: "172.22.0.100"
#Mapping local folders (puppet code) to the VM
    puppet.vm.synced_folder("puppet/hieradata","/tmp/vagrant-hiera/hieradata")
    puppet.vm.synced_folder("eyaml-keys","/tmp/vagrant-eyaml")
#VM specifications.
    puppet.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id,
        '--memory', '2048',
        '--cpus', '1'
      ]
    end
  }
#Puppet provsisioner configuration
  config.vm.provision :puppet do |puppet|
    puppet.module_path = ["puppet/modules/infra","puppet/modules/resources"]
    puppet.manifests_path = "puppet/manifests"
    puppet.environment_path = "environment"
    puppet.environment = "prod"
    puppet.manifest_file = "site.pp"
    puppet.options = []
    puppet.options << "--verbose"
    puppet.working_directory = "/tmp/vagrant-hiera"
    puppet.hiera_config_path = "hiera.yaml"
  end
end
