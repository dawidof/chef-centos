Configure centos with CHEF
===================

This helps to configure centos to use Ruby on Rails
It could install:
	

- RVM
- List item
- Passenger
- Rails
- set bash_profile
- configure ssh ( port 4500 )
- PostgreSQL
- MySQL
- create new user
- configure FTP
	
make 

    mkdir /etc/chef
    yum install ruby -y
    curl -L https://www.opscode.com/chef/install.sh | bash
    cd /etc/chef
    
    git clone https://github.com/dawidof/chef-centos.git
    ruby init.rb