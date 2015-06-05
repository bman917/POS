module ItemsHelper

  # Given
  # "attrib"=>{
  #   "2"=>"12mm", "4"=>"Linso", "6"=>"White", 
  #   "7"=>"Class C, Class D, Class E",
  #   "8"=>"Fi, Fai, Fo, Fum"}, "commit"=>"Save"
  # }
  #
  # This will generate:
  # {"2"=>"12mm", "4"=>"Linso", "6"=>"White", "7"=>"Class C"}
  # {"2"=>"12mm", "4"=>"Linso", "6"=>"White", "7"=>"Class D"}
  # {"2"=>"12mm", "4"=>"Linso", "6"=>"White", "7"=>"Class E"}
  #
  def self.generate_attribs(attribs)
    attribs_clone = attribs.clone

    commas = attribs_clone.select do | key, value |
      value.include? ","
    end
    
    no_comma = attribs_clone.select do | key, value |
      !value.include? ","
    end

    raise ArgumentError if commas.size > 1

    if commas.nil? || commas.empty?
      puts "Items: #{attribs_clone}"
      [attribs_clone]
    else
      puts "commas   : #{commas}"
      puts "no_comma: #{no_comma}"

      comma_attrib_key = commas.keys.first
      comma_attrib_values = commas[comma_attrib_key].split(",")

      items = []

      comma_attrib_values.each do | v |
        clone = no_comma.clone
        clone[comma_attrib_key] = v
        items << clone
      end

      puts "Items: #{items}" 
      items
    end

  end
end
