require "rails_helper"

describe ItemsHelper do
  describe "Comma Delimited Attributes" do 
    describe "No comma-delimited scenarios" do
      params = {"utf8"=>"✓", "authenticity_token"=>"H2ZFASTKq+SW1SodPzrqEWx6M3YvzDke62dj8HggJH4=", "item"=>{"item_base_id"=>"4", "supplier_id"=>"5", "unit"=>"bottle", "description"=>""}, "attrib"=>{"6"=>"SSSSSS"}, "commit"=>"Save"}
      it "Does not error" do
        expect{ItemsHelper.generate_attribs(params["attrib"])}.to_not raise_error
      end      
      it "Does not error when there are no comma-delimited attribs" do
        expect(ItemsHelper.generate_attribs(params["attrib"]).class).to eq Array
      end      
    end

    it "Rasies an error if more than one attrib is comma-delimited" do
      params = {"utf8"=>"✓", "authenticity_token"=>"H2ZFASTKq+SW1SodPzrqEWx6M3YvzDke62dj8HggJH4=", 
        "item"=>{"item_base_id"=>"1", "supplier_id"=>"1", "unit"=>"sheet", "description"=>""}, 
        "attrib"=>{"2"=>"12mm", "4"=>"Linso", "6"=>"White", 
          "7"=>"Class C, Class D, Class E",
          "8"=>"Fi, Fai, Fo, Fum"}, "commit"=>"Save"}

      orig_attribs = params["attrib"]
      expect{ItemsHelper.generate_attribs(orig_attribs)}.to raise_error

    end
    
    it "creates multiple items" do
      params = {"utf8"=>"✓", "authenticity_token"=>"H2ZFASTKq+SW1SodPzrqEWx6M3YvzDke62dj8HggJH4=", 
        "item"=>{"item_base_id"=>"1", "supplier_id"=>"1", "unit"=>"sheet", "description"=>""}, 
        "attrib"=>{"2"=>"12mm", "4"=>"Linso", "6"=>"White", 
          "7"=>"Class C, Class D, Class E"}, "commit"=>"Save"}

      orig_attribs = params["attrib"]     

      attribs = ItemsHelper.generate_attribs(orig_attribs) 

      expect(attribs.size).to eq 3
    end
  end
end