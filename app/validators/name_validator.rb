class NameValidator < ActiveModel::Validator
  def validate(record)
    result = Category.find_by_name(record.name)
    if result
      record.errors[:base] << "'#{record.name}' category already exists."
    end
  end
end