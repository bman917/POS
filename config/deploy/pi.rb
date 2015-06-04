# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

# ===============================
# This is the fix for this error:
#   passenger-config stderr: *** ERROR: You are not authorized to query the status for this Phusion Passenger instance. Please try again with 'rvmsudo'.
#set :passenger_restart_with_touch, true
set :rvm_map_bins, %w{gem rake ruby bundle rvmsudo}
set :default_env, { :RUBY_ENV => 'pi' }
set :passenger_restart_command, 'rvmsudo passenger-config restart-app'
# ===============================

set :branch, 'prod'
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
#ask(:MYSQL_PASSWORD, nil, echo: false)
#set :default_env, { :MYSQL_PASSWORD => fetch(:MYSQL_PASSWORD) }

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.
server '192.168.0.124', user: 'pi', roles: %w{web app db}


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
