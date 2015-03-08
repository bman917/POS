# This file was generated by the `rails generate rspec:install` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause this
# file to always be loaded, without a need to explicitly require it in any files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, make a
# separate helper file that requires this one and then use it only in the specs
# that actually need it.
#
# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
# The settings below are suggested to provide a good initial experience
# with RSpec, but feel free to customize to your heart's content.
=begin
  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax
    expectations.syntax = :expect
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    # For more details, see:
    #   - http://teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end
=end
end

def sign_in 
  @admin = UserManager::User.find_by_username('admin')
  if @admin == nil
    puts "Creating Admin user..."
    @admin = UserManager::User.create(username: 'admin', password: 'password', email: 'noreply@email.com')
  end
  
  visit user_manager.new_user_session_path
  fill_in 'user_username', :with => 'admin'
  fill_in 'user_password', :with => 'password'
  click_button 'Sign in'
end

def expect_html_focus_on(element_id)
  sleep 0.5
  activeElement_id = page.evaluate_script("document.activeElement.id").to_s
  expect(activeElement_id == element_id).to be_truthy
end

shared_examples "a modal form" do
  it "can be closed" do
    expect(page).to have_css('a.close-reveal-modal')
    find("a.close-reveal-modal").click
    expect(page).to have_no_css('a.close-reveal-modal')
  end
end

def fill_autocomplete(field, options = {})
  fill_in field, with: options[:with]

  page.execute_script %Q{ $('##{field}').trigger('focus') }
  page.execute_script %Q{ $('##{field}').trigger('keydown') }
  selector = %Q{ul.ui-autocomplete li.ui-menu-item:contains("#{options[:with]}")}

  if options[:not_found]
    sleep 1
    page.assert_no_selector('ul.ui-autocomplete li.ui-menu-item')
  else
    expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item')
    page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
  end
end

#Clikc on a PO in the Purchase Order table
def click_po_on_purchase_order_table(purchase_order)
  po_css_id = "#purchaseorder#{purchase_order.id}"
  page.evaluate_script("$('#{po_css_id} td').click();")
  within ("#purchase_order_show_details") do
    expect(page).to have_content("PO# #{purchase_order.po_id}")
  end
end

