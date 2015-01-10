module ItemBasesHelper

  # :header => {"Attribute"=>1, "Topway"=>2, "Marikina Rubber Corporation"=>3},
  # :rows => [
  #     {1 => "Thickness" , 2 => "7mm", 3=> "7mm"},
  #     {1 => "Color"     , 2 => "Blk", 3=> "Wht"},
  #     ...
  #   ]

  def gen_table(item_base)
    table = {}
    table[:header] = {"Attribute" => 1}
    table[:rows] = []

    map = @item_base.map_by_attrib_then_supplier
    puts "Working with: #{map}"

    map.each do | attrib, suppliers | 
      suppliers.each do | name, value_set |
        unless  table[:header].include? name
          col_index = table[:header].size + 1
          table[:header].store(name, col_index)
        end
      end

      row = { 1 => attrib}
      table[:rows] << row

      table[:header].each do | supplier_name, col_index |
        puts "Processing col_index: #{col_index} == #{map[attrib][supplier_name].to_a}"
        row.store(col_index, map[attrib][supplier_name]) unless col_index == 1
      end
    end
    puts "Table: #{table}"

    table
  end
end
