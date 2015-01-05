class AddDefaultAttribs < ActiveRecord::Migration
  def up
    puts 'Adding default attribs....'
    Attrib.create(name: 'Color')
    Attrib.create(name: 'Size')
    Attrib.create(name: 'Thickness')
    Attrib.create(name: 'Grade')
    Attrib.create(name: 'Texture')
  end
end
