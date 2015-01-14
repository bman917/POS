# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase_order do
    supplier nil
    status "MyString"
    notes "MyText"
    date "2015-01-14"
  end
end
