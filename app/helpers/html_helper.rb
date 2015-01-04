module HtmlHelper
    #Creates a small div. 1 Row + 1 Column
  def small_div
    content_tag :div, class: 'row' do
      content = content_tag :div, class: 'columns small-7' do
        yield
      end
    end.html_safe
  end

  #Creates a CSS for the model
  def css_id(model)
    "#{model.class.to_s.downcase}#{model.id}"
  end

  #Helper method for creating a table row.
  #Adds a tr id for the model.
  #Adds a tr.highlight css if the row is equal to the new model 
  def tr_highlight(model, new_model)
    css_class = "highlight" if model.id == new_model.try(:id)
    content_tag :tr, id: css_id(model), class: css_class do
      yield
    end
  end
end