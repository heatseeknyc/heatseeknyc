Feature: Administer Tenant Sensors
  Scenario: Admin wants to modify a cell assignment for specific tenant
    Given I am an admin
    And I have a tenant
    When I go to account settings page for the tenant
    And I change the cell number to a new one
    And I hit save
    And I see a status notification about the change at the top
    And I see that the cell number is updated
