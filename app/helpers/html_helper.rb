module HtmlHelper

  #Standard wrapper for main heading
  def page_title(title)
    content_tag :h4, class: 'title' do
      title
    end.html_safe
  end

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

  #Helper method for creating a table row.
  #Adds a tr id for the model.
  #Adds a tr.highlight css if the row is equal to the new model 
  def tr_highlight_simple(model, new_model)
    h = "highlight" if model.id == new_model.try(:id)
    n = " new" if model.created_at.to_date == Date.today

    css_class = "#{h} #{n}".squeeze(' ').strip

    content_tag :tr, id: model.id, class: css_class do
      yield
    end
  end

  def div_row(size, options={})
    size = 12 if size == "max"

    options[:class] ||= "row"

    unless options[:class].include?("row")
      options[:class] = options[:class] + " row"
    end



    content_tag :div, options do
      content = content_tag :div, class: "columns small-#{size}" do
        yield
      end
    end.html_safe
  end
end