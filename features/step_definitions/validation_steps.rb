################################################################################
# validation_steps.rb is used to confirm that certain elements are displayed on the page.

Then(/^text "([^"]*)" should display$/) do |string|
  browser.wait(:html => /#{string}/i)
end

Then(/^the user should be on page "(.*?)"$/) do |page|
  # Get the expected url
  expected_url = env('pages.root')
  expected_url += env("pages.#{page}")

  # A custom loop that waits 5 seconds until the expected_url is the same as the current url
  start = Time.now
  while browser.url != expected_url
    break if (Time.now - start).to_i >= 5
    sleep(0.1)
  end

  # Check if they are the same
  if browser.url != expected_url
    error("The current URL and expected URL were not the same: \n Current: #{browser.url}\n Expected: #{expected_url}")
  end
end

Then(/^we should see at least (\d+) flight options$/) do |expected_options|
  number_of_flights = browser.divs(:class => /day-with-availability/).count
  if number_of_flights < expected_options.to_i
    error "We see '#{browser.divs(:class => /day-with-availability/).count}' flight options."
  end
end

Then(/^the price of the selected flight should be less than "([^"]*)"$/) do |max_price|
  active_selection = browser.wait(:like => [:div, :class, 'is-selected'])

  price =  browser.wait(:like => [:span, :class, 'currency'],
                        :context => active_selection).text.to_i

  if price > max_price.to_i
    error "Price of selected flight is '#{price}'."
  end
end