class AddDefaultAttribs < ActiveRecord::Migration
  def up
    puts 'Adding default attribs....'
    Attrib.create(name: 'Thickness', display_number: 1)
    Attrib.create(name: 'Size'     , display_number: 2)
    Attrib.create(name: 'Design'   , display_number: 3)
    Attrib.create(name: 'Texture'  , display_number: 4)
    Attrib.create(name: 'Color'    , display_number: 5)
    Attrib.create(name: 'Grade'    , display_number: 6)
    Attrib.create(name: 'Model'    , display_number: 7)
  end
end
