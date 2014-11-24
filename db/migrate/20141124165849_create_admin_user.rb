class CreateAdminUser < ActiveRecord::Migration
  def up
    puts 'Looking for admin user....'
    user = User.where(username: 'admin').first
    if user
      puts "Setting role to 'Admin'"
      user.role = 'Admin'
      user.save!
    else
      puts "Creating admin user...."
      user = User.new(username: 'admin', email: 'change.me@notreal.com', password: 'password', role: 'Admin')
      user.save!
      puts "Done: #{user}"
    end
  end
end