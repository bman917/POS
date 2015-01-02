class AddDefaultAttributes < ActiveRecord::Migration
  def up
    puts 'Adding default attributes....'
    Attribute.create(name: 'Color')
    Attribute.create(name: 'Size')
    Attribute.create(name: 'Thickness')
    Attribute.create(name: 'Grade')
    Attribute.create(name: 'Texture')
  end
end
