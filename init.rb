#!/usr/bin/ruby

vars = {
	"username": {label: 'User', default: 'dawidof'},
	"user_password": {label: 'User password', default: "P@$$w0rd"},
	"domain": {label: 'Domain'},
	"site_folder": {label: 'Site folder', default: :domain},
	"install_mysql": {label: 'Install Mysql', bool: true, additional: {
		'mysql_login': {label: 'MySQL Login', default: :username},
		'mysql_pass': {label: 'MySQL Password', default: :user_password},
		}
	},
	"install_posqtgresql": {label: 'Install PostgreSQL', bool: true, additional: {
		'posqtgres_login': {label: 'PosgreSQL Login', default: :username},
		'posqtgres_pass': {label: 'PosgreSQL Password', default: :user_password},
		}
	},

	"env_db_pass": {label: 'Env. DB PASS (export APP_DATABASE_PASSWORD)', default: :domain},
	"ram": {label: 'RAM (512, 1, 2, 4, 8, 16, 32, 64)', default: '512'},
	"ruby_version": {label: 'Ruby version', default: '2.2.3'},
	"rails version": {label: 'Rails version', default: '4.2.5'},
}

vars.each do |var|
	v = var[0]
	hash = var[1]

	if hash.has_key? :label
		label = hash[:label]
		# label += " [" + hash[:default] + "]" if hash.has_key? :default
		if hash[:default].is_a? Symbol
			if v == :env_db_pass
				label += " [" + instance_variable_get("@#{hash[:default].to_s}").to_s.split('.').first.upcase + "]"
			else
				label += " [" + instance_variable_get("@#{hash[:default].to_s}").to_s + "]"
			end
		elsif hash.has_key? :default
			label += " [" + hash[:default] + "]" 
		end

		label += ": "
		print label
	end
	
	input = gets.chomp
	if v == :env_db_pass
		vv = (input == "" ? instance_variable_get("@#{hash[:default].to_s}").to_s.split('.').first.upcase : input)
	else
		vv = ((hash.has_key? :default and input == "") ? (hash[:default].is_a?(Symbol) ? instance_variable_get("@#{hash[:default].to_s}").to_s : hash[:default]) : input)
		# vv = ((hash.has_key? :default and input == "") ? hash[:default] : input)
	end

	if hash.has_key? :bool and hash[:bool] == true
	    vv = 'true' if vv =~ (/^(true|t|yes|y|1)$/i)
	    vv = 'false' if vv =~ (/^(false|f|no|n|0)$/i)
	    if vv == 'true' and hash.has_key? :additional
	    	hash[:additional].each do |var_2|
	    		hash_2 = var_2[1]
	    		v_2 = var_2[0]
	    		if hash_2.has_key? :label
	    			label = "\t" + hash_2[:label].to_s
	    			if hash_2.has_key? :default
	    				if hash_2[:default].is_a? Symbol
	    					label += " [" + instance_variable_get("@#{hash_2[:default].to_s}").to_s + "]"
	    				else
			    			label += " [" + hash_2[:default] + "]" 
			    		end
			    	end
	    			label += ": "
	    			print label
	    		end
	    		
	    		input_2 = gets.chomp
	    		vv_2 = ((hash_2.has_key? :default and input_2 == "") ? (hash_2[:default].is_a?(Symbol) ? instance_variable_get("@#{hash_2[:default].to_s}").to_s : hash_2[:default]) : input_2)
	    		instance_variable_set("@#{v_2.to_s}", vv_2)
	    	end
	    end

	end
    instance_variable_set("@#{v.to_s}", vv)
end


if defined? @env_db_pass
	@env_db_pass += "_DATABASE_PASSWORD" unless @env_db_pass.include? '_DATABASE'
end


puts ""
puts ""
puts "Values: "

vars.each do |var|
	puts var[1][:label] + ": " + instance_variable_get("@#{var[0].to_s}").to_s
	if var[1].has_key? :additional and instance_variable_get("@#{var[0].to_s}").to_s == 'true'
		var[1][:additional].each do |var_2|
			puts "\t" + var_2[1][:label].to_s + ": " + instance_variable_get("@#{var_2[0].to_s}").to_s

		end
	end
end

