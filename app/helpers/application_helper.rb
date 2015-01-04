module ApplicationHelper



  # Opens the contents of the link using Zurb Foundation's Reveal Modal.
  # The controller of the resource should render layout: false  
  def modal_link_to(name, options=nil, html_options={})
    if html_options[:data] == nil
      html_options[:data] = {:"reveal-ajax" => true, :"reveal-id" => "modal_form"}
    end
    link_to(name, options, html_options)
  end

  # Opens the contents of the link using Zurb Foundation's Reveal Modal.
  # The controller of the resource should render layout: false  
  # Adds button css class
  def modal_button(name, options=nil, html_options={})
    if html_options[:class] == nil
      html_options[:class] = 'button'
    elsif html_options[:class].include?('button') == false
      html_options[:class] += ' button'
    end
    modal_link_to(name, options, html_options)
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
end
