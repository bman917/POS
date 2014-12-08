# This migration comes from user_manager (originally 20141125175642)
class CreateAdminUser < ActiveRecord::Migration
  def up
    puts 'Looking for admin user....'
    user = UserManager::User.where(username: 'admin').first
    if user
      puts "Setting role to 'Admin'"
      user.role = 'Admin'
      user.save!
    else
      puts "Creating admin user...."
      user = UserManager::User.new(username: 'admin', email: 'change.me@notreal.com', password: 'password', role: 'Admin')
      user.save!
      puts "Done: #{user}"
    end
  end
end