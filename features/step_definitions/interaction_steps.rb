################################################################################
# interactions_steps.rb is used to interact with elements on the page.

Given(/^the user navigates to the "(.*?)" page$/) do |page|
  # Get the value of the configuration (see /config/config.yml)

  # First grab the root URL defined in the config
  url = env('pages.root')
  # Then add the page specific part to the URL
  url += env("pages.#{page}")

  # Go to the URL
  browser.goto url
end

Given(/^accepts the cookies$/) do
  #Silently continue if button is not found
  browser.find(:like => [:button, :class, 'cookie-consent-close']).click rescue ""
end

When(/^the user searches for the following flight$/) do |table|

  # Filling in the following values on the page
  # | from, to, depart on, return on, passengers

  table.hashes.each do |flight|

    #First check if we can calculate the departure and return days
    # Compute day (requires gem chronic).
    departure_day = Chronic.parse(flight["depart on"])
    # Will be nil if unable to parse
    if not departure_day
      error "Unable to parse '#{flight["depart on"]}'. See https://github.com/mojombo/chronic for details"
    end

    # Compute return (requires gem chronic).
    return_day = Chronic.parse(flight["return on"], :now => departure_day)
    # Will be nil if unable to parse
    if not return_day
      error "Unable to parse '#{flight["return on"]}'. See https://github.com/mojombo/chronic for details"
    end

    sleep 2

    # Set the 'from' value
    p "Selecting: " + flight["from"]
    location = browser.wait(:like => [:input, :id, 'DepartureStation'])
    location.flash
    location.clear
    location.send_keys flight["from"]
    location.send_keys :tab
    sleep 1

    # Set the 'to' value
    p "Selecting: " + flight["to"]
    location = browser.wait(:like => [:input, :id, 'ArrivalStation'])
    location.flash
    location.clear
    location.send_keys flight["to"]
    location.send_keys :tab
    sleep 1

    p "Selecting: #{flight["depart on"]} (#{departure_day.strftime('%d %b %Y')})"
    #TODO: Add logic to handle datepicker
    depart_on = browser.wait(:like => [:input, :id, 'OutboundDate'])
    depart_on.focus
    depart_on.flash
    depart_on.clear
    depart_on.send_keys departure_day.strftime('%d %b %Y')
    location.send_keys :tab
    sleep 1

    p "Selecting: #{flight["return on"]} (#{return_day.strftime('%d %b %Y')})"
    return_on = browser.wait(:like => [:input, :id, 'IsReturnFlight'])
    return_on.flash
    return_on.clear
    return_on.send_keys return_day.strftime('%d %b %Y')
    location.send_keys :tab
    sleep 1

    p "Selecting: " + flight["passengers"]
    #Open passenger select popup
    passengers_selection = browser.wait(:like => [:input, :id, 'booking-passengers-input'])
    passengers_selection.flash
    passengers_selection.click
    passengers_panel = browser.wait(:like => [:div, :class, 'togglepanel-passengers'])
    passengers_panel.text_fields[0].flash
    passengers_panel.text_fields[0].clear                     #resets it to 1
    passengers_panel.text_fields[0].send_keys(:backspace)     #clears input completely
    passengers_panel.text_fields[0].set /[0-9]* adult/.match(flight["passengers"]).to_s.to_i
    passengers_panel.text_fields[1].clear                     #resets it to 0
    passengers_panel.text_fields[1].send_keys(:backspace)     #clears input completely
    passengers_panel.text_fields[1].set /[0-9]* child/.match(flight["passengers"]).to_s.to_i
    passengers_panel.text_fields[2].clear                     #resets it to 0
    passengers_panel.text_fields[2].send_keys(:backspace)     #clears input completely
    passengers_panel.text_fields[2].set /[0-9]* bab/.match(flight["passengers"]).to_s.to_i

    #Save passengers
    browser.wait(:like => [:button, :text, 'Save']).click

    sleep 1
  end

  #Click search button
  browser.wait(:like => [:button, :type, 'submit']).click
end
