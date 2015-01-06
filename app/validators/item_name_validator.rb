class ItemNameValidator < ActiveModel::Validator
  def validate(record)
    result = Item.where(name: record.name, supplier: record.supplier, unit: record.unit)
    if result.try(:count) > 0
      record.errors[:base] << "#{record.supplier.name}, '#{record.name} #{record.unit}' already exists."
    end
  end
end