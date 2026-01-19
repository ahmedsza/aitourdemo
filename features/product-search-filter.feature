Feature: Product Search and Filtering
  As an administrator
  I want to search and filter products
  So that I can quickly find specific products in the inventory

  Background:
    Given the ZAVA Backoffice application is running
    And I am on the product management page
    And the following products exist:
      | Name                    | Description                           | Price  | Category        |
      | Smart Watch Pro         | Advanced fitness tracking watch       | 299.99 | Electronics     |
      | Wireless Headphones     | Noise-canceling bluetooth headphones  | 199.99 | Electronics     |
      | Running Shoes Elite     | Professional running shoes            | 149.99 | Sports          |
      | Yoga Mat Premium        | Extra thick yoga mat                  | 49.99  | Sports          |
      | Organic Green Tea       | Premium loose leaf tea                | 19.99  | Food & Beverage |
      | Coffee Maker Deluxe     | Programmable coffee machine           | 89.99  | Electronics     |
      | Protein Powder          | Whey protein isolate                  | 39.99  | Health & Beauty |

  # Happy Path Scenarios
  Scenario: Search products by name
    When I type "watch" in the search field
    Then I should see 1 product in the results
    And the product "Smart Watch Pro" should be visible

  Scenario: Search products by partial name match
    When I type "shoes" in the search field
    Then I should see 1 product in the results
    And the product "Running Shoes Elite" should be visible

  Scenario: Search products by description
    When I type "bluetooth" in the search field
    Then I should see 1 product in the results
    And the product "Wireless Headphones" should be visible

  Scenario: Search is case-insensitive
    When I type "YOGA MAT" in the search field
    Then I should see 1 product in the results
    And the product "Yoga Mat Premium" should be visible

  Scenario: Filter products by category
    When I select "Electronics" from the category filter
    Then I should see 3 products in the results
    And all visible products should have category "Electronics"

  Scenario: Filter products by another category
    When I select "Sports" from the category filter
    Then I should see 2 products in the results
    And the following products should be visible:
      | Name                |
      | Running Shoes Elite |
      | Yoga Mat Premium    |

  Scenario: Combine search and category filter
    When I type "premium" in the search field
    And I select "Sports" from the category filter
    Then I should see 1 product in the results
    And the product "Yoga Mat Premium" should be visible

  Scenario: Clear search to show all products
    Given I have searched for "watch"
    When I clear the search field
    Then I should see 7 products in the results

  Scenario: Reset category filter to show all categories
    Given I have filtered by category "Electronics"
    When I select "All Categories" from the category filter
    Then I should see 7 products in the results

  # Edge Cases
  Scenario: Search with no matching results
    When I type "spaceship" in the search field
    Then I should see 0 products in the results
    And I should see an empty state message

  Scenario: Search with very short query
    When I type "a" in the search field
    Then I should see products containing "a" in name or description

  Scenario: Search with special characters
    When I type "@#$%" in the search field
    Then I should see 0 products in the results
    And the application should handle the query without errors

  Scenario: Filter by category with no products
    Given all products are deleted from "Books" category
    When I select "Books" from the category filter
    Then I should see 0 products in the results
    And I should see the message "No Products Yet"

  Scenario: Search updates results in real-time
    When I type "w" in the search field
    Then I should see 2 products matching the query
    When I continue typing "atch"
    Then I should see 1 product in the results
    And the product "Smart Watch Pro" should be visible

  Scenario: Search with leading and trailing spaces
    When I type "  watch  " in the search field
    Then the search should trim the spaces
    And I should see 1 product in the results

  Scenario: Apply multiple filters and search combinations
    When I select "Electronics" from the category filter
    And I type "wireless" in the search field
    Then I should see 1 product in the results
    And the product "Wireless Headphones" should be visible

  # Boundary Cases
  Scenario: Search with empty string
    When I clear the search field completely
    Then all 7 products should be displayed

  Scenario: Filter with no category selected
    When the category filter is set to "All Categories"
    Then all 7 products should be displayed

  Scenario: Search for numeric values in description
    When I type "299" in the search field
    Then the search should work correctly
    # Note: Search typically works on text fields, not price

  Scenario: Very long search query
    When I type a 500 character search string
    Then the application should handle the query without errors
    And performance should remain acceptable

  # Error Scenarios
  Scenario: Network error while loading products for search
    Given the API is temporarily unavailable
    When I navigate to the product management page
    Then I should see an error message "Error loading products"
    And the search functionality should be gracefully disabled

  Scenario: Products fail to load during filter operation
    Given products are loaded initially
    When the API connection is lost
    And I attempt to filter by category
    Then the application should continue working with cached data

  # Performance Scenarios
  Scenario: Search with large product inventory
    Given there are 1000 products in the system
    When I type "premium" in the search field
    Then the search results should update within 1 second
    And the UI should remain responsive

  Scenario: Rapid filter changes
    When I rapidly change category filters 10 times
    Then each filter change should complete successfully
    And the final results should match the last selected category

  # Accessibility Scenarios
  Scenario: Search field is keyboard accessible
    When I press Tab to focus the search field
    And I type "headphones" using the keyboard
    Then the search results should update automatically
    And the results should be announced to screen readers

  Scenario: Filter dropdown is keyboard accessible
    When I press Tab to focus the category filter dropdown
    And I press the down arrow key to open the dropdown
    And I use arrow keys to navigate to "Sports"
    And I press Enter to select the category
    Then products should be filtered to "Sports" category

  Scenario: Search results are accessible to screen readers
    When I search for "watch"
    Then the results count should be announced
    And each product in the results should be navigable by screen reader

  Scenario: Empty search results provide clear feedback
    When I search for "nonexistent"
    Then the empty state should have proper semantic markup
    And screen readers should announce "No products found"

  Scenario: Filter changes are announced
    When I change the category filter to "Electronics"
    Then screen readers should announce the new filter state
    And the updated results count should be communicated
