module FoundationHelper
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
      html_options[:class] = 'pos_action'
    elsif html_options[:class].include?('pos_action') == false
      html_options[:class] += ' pos_action'
    end
    modal_link_to(name, options, html_options)
  end
end