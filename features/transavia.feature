@transavia @p
Feature: Transavia Technical Assignment
  In order to find the right flights and availability fast
  As a user on the website
  I want to navigate quickly to the flight details and check the availability

  @trans01 @flights
  Scenario Outline: trans01 - Check flight availability
    Given the user navigates to the "nl" page
    And accepts the cookies
    When the user searches for the following flight
      | from   | to   | depart on   | return on   | passengers   |
      | <from> | <to> | <depart on> | <return on> | <passengers> |
    Then the price of the selected flight should be less than "<max_price>"
    And we should see at least <min_results> flight options
  Scenarios: Values of the scenarios
    | from      | to     | depart on  | return on     | passengers       | min_results | max_price |
    | Amsterdam | Lisbon | in 1 month | after 2 weeks | 2 adults 1 child | 4           | 400       |
    | Eindhoven | Nice   | in 2 weeks | after 10 days | 1 adult 1 baby   | 4           | 200       |

  @trans02 @menu
  Scenario Outline: trans02 - Main menu navigation
    Given the user navigates to the "<country>" page
    When the user selects "<submenu>" from the main menu section "<mainmenu>"
    Then the user should be on url "<destination_url>"
    Scenarios: Values of the scenarios
      | country | mainmenu              | submenu         | destination_url |
      | nl      | Plan en boek          | Boek een vlucht | /vluchten       |
      | fr      | Planifiez et réservez | Réservez un vol | /vols           |

  @trans03 @account
  Scenario: trans02 - Account creation
    Given the user navigates to the "nl" page
    When the user navigates to the create account page
    And creates a valid account
    Then the user should be logged in