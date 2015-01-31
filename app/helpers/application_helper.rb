module ApplicationHelper

  def get_params(active_record_query)
    params = {}

    active_record_query.where_values.each do |where_value|
      params[where_value.left.name] = where_value.right
    end

    return params
  end
end
