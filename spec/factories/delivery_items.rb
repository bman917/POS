# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :delivery_item do
    item nil
    delivery nil
    purchase_order nil
    quantity 1
    unit_price 1.5
    total_price 1.5
    notes "MyText"
  end
end
