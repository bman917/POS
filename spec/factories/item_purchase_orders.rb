# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_purchase_order do
    item nil
    purchase_order nil
    quantity 1
    estimated_unit_price 1.5
    estimated_total_price 1.5
    notes "MyString"
  end
end
