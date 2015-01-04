module ApplicationHelper

  # Opens the contents of the link using Zurb Foundation's Reveal Modal.
  # The controller of the resource should render layout: false  
  def modal_link_to(name, options=nil, html_options={})
    if html_options[:data] == nil
      html_options[:data] = {:"reveal-ajax" => true, :"reveal-id" => "modal_form"}
    end
    link_to(name, options, html_options)
  end

  def modal_button(name, options=nil, html_options={})
    if html_options[:class] == nil
      html_options[:class] = 'button'
    elsif html_options[:class].include?('button') == false
      html_options[:class] += ' button'
    end
    modal_link_to(name, options, html_options)
  end

end
