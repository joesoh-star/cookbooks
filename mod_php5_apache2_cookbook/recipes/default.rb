case node[:platform]
    
    when "amazon"

    include_recipe "build-essential"
    include_recipe "apache2::default"
    include_recipe "apache2::mod_rewrite"

    
    # remove any existing php/mysql
    execute "yum remove -y php* mysql*"
    
    # get the metadata
    execute "yum -q makecache"
    
    # manually install php 5.5
    execute "yum install -y php55 php55-devel php55-cli php55-snmp php55-soap php55-xml php55-xmlrpc php55-process php55-mysqlnd php55-pecl-memcache php55-opcache php55-pdo php55-imap php55-mbstring php55-intl"

  when "rhel", "fedora", "suse", "centos"
  # add the webtatic repository
  yum_repository "webtatic" do
    repo_name "webtatic"
    description "webtatic Stable repo"
    url "http://repo.webtatic.com/yum/el6/x86_64/"
    key "RPM-GPG-KEY-webtatic-andy"
    action :add
  end

  yum_key "RPM-GPG-KEY-webtatic-andy" do
    url "http://repo.webtatic.com/yum/RPM-GPG-KEY-webtatic-andy"
    action :add
  end
  
  node.set['php']['packages'] = ['php55', 'php55-devel', 'php55-cli', 'php55-snmp', 'php55-soap', 'php55-xml', 'php55-xmlrpc', 'php55-process', 'php55-mysqlnd', 'php55-pecl-memcache', 'php55-opcache', 'php55-pdo', 'php55-imap', 'php55-mbstring', 'php55-intl']

  include_recipe "build-essential"
  include_recipe "apache2::default"
  include_recipe "apache2::mod_rewrite"
  include_recipe "php"

  when "debian"
    include_recipe "apt"
	apt_repository "wheezy-php55" do
		uri "#{node['php55']['dotdeb']['uri']}"
		distribution "#{node['php55']['dotdeb']['distribution']}-php55"
		components ['all']
		key "http://www.dotdeb.org/dotdeb.gpg"
		action :add
	end
	
	  include_recipe "php"
  end