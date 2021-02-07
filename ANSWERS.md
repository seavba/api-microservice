 # API microservice

 1. **How long did it take to finish the test?**

 It took about 14 hours, including the time spent documenting the test.

 **2.If you had more time, how could you improve your solution?**

 I think there are a lot of ways to improve it. First of all, the NGINX could run over a docker container and the VM could be the docker host only.
 The container could be created from Puppet and then apply my module.

 For my personal preferences, I'd do it using ansbile and docker compose, because, from my point of view, Ansible is more human friendly than Puppet and agent-less. Docker compose makes the service configuration really easy.

 **3.What changes would you do to your solution to be deployed in a production environment?**

 A lot of them :smile:... I mean, I'd change:
   - The self-signed certificate by a trusted one.
   - NGINX access restricted by user and password on default servers (vhosts) and in PHP application, if it would be possible.
   - Firewall rules applied on the host (vbox) restricting the sources allowed to connect.
   - Add NGINX checks that could help with the application monitoring.
   - In my module, only one PHP file could be uploaded, I'd change for accepting folders

 **4.Why did you choose this language over others?**

  If the question refers to the application, I chose PHP because in the past, I did nice jobs (always sequential) and I managed JSON's file in an easy way using it, so that's was the reason why I used PHP.

  However, if the question refers to the configuration manage tool, I chose Puppet because, if I'm not wrong, you are using it as your CM tool and I work every day with it, so, I thought this way I could show you my Puppet skills.

 **5.What was the most challenging part and why?**

 Well, the most challenging part was to set the maximum elements in the hiera yaml file to be configured in a flexible way because I never used nginx module and I stuck a bit on the servers and locations settings. An example was ssl_redirect, I was trying to add the rewrite rule using location_cfg_append or server_cfg_append params until I realized that using ssl_redirect was enough :bow:
