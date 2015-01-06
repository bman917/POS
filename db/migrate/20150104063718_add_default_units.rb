class AddDefaultUnits < ActiveRecord::Migration
  def up
    puts 'Adding default units...'
    Unit.create(name: 'bottle', abbrev: 'btl')
    Unit.create(name: 'box', abbrev: 'box')
    Unit.create(name: 'meter', abbrev: 'mtr')
    Unit.create(name: 'piece', abbrev: 'pcs')
    Unit.create(name: 'pair', abbrev: 'prs')
    Unit.create(name: 'gallon', abbrev: 'gln')
    Unit.create(name: 'roll', abbrev: 'rol')
    Unit.create(name: 'kilo', abbrev: 'kgs')
    Unit.create(name: 'pound', abbrev: 'lbs')
    Unit.create(name: 'case', abbrev: 'cse')
    Unit.create(name: 'sheet', abbrev: 'sht')
  end
end
