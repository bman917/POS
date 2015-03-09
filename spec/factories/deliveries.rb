# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :delivery do
    date "2015-03-09"
    supplier nil
    supplier_dr_number "MyString"
    notes "MyText"
  end
end
