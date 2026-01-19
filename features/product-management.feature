Feature: Product Management
  As an administrator
  I want to manage products in the inventory
  So that I can maintain an up-to-date product catalog

  Background:
    Given the ZAVA Backoffice application is running
    And I am on the product management page

  # Happy Path Scenarios
  Scenario: View empty product inventory
    Given there are no products in the system
    When I navigate to the product management page
    Then I should see the message "No Products Yet"
    And I should see the message "Start by adding your first product"

  Scenario: Add a new product with all fields
    When I click the "ADD PRODUCT" button
    And I fill in the product form with:
      | Field       | Value                                    |
      | Name        | Premium Wireless Headphones              |
      | Description | High-quality noise-canceling headphones  |
      | Price       | 199.99                                   |
      | Category    | Electronics                              |
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product "Premium Wireless Headphones" should appear in the inventory table
    And the product should display price "$199.99"
    And the product should display category "Electronics"

  Scenario: Add a product with only required fields
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Basic Item"
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product "Basic Item" should appear in the inventory table
    And the product should display price "$0.00"
    And the product should display category "General"

  Scenario: Edit an existing product
    Given a product exists with name "Laptop Computer"
    When I click the "EDIT" button for product "Laptop Computer"
    And I update the product name to "Gaming Laptop"
    And I update the price to "1599.99"
    And I submit the product form
    Then I should see a success message "Product updated successfully!"
    And the product "Gaming Laptop" should appear in the inventory table
    And the product should display price "$1,599.99"

  Scenario: Delete a product
    Given a product exists with name "Old Inventory Item"
    When I click the "DELETE" button for product "Old Inventory Item"
    And I confirm the deletion in the dialog
    Then I should see a success message "Product deleted successfully!"
    And the product "Old Inventory Item" should not appear in the inventory table

  Scenario: View all products in inventory
    Given the following products exist:
      | Name                     | Price  | Category    |
      | Smart Watch Pro          | 299.99 | Electronics |
      | Running Shoes Elite      | 149.99 | Sports      |
      | Organic Green Tea        | 19.99  | Food & Beverage |
    When I navigate to the product management page
    Then I should see 3 products in the inventory table
    And each product should display its name, price, and category

  # Boundary and Edge Cases
  Scenario: Add product with minimum price
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Free Sample"
    And I fill in the product price with "0.00"
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product should display price "$0.00"

  Scenario: Add product with very long name
    When I click the "ADD PRODUCT" button
    And I fill in the product name with a 200 character string
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product name should be displayed in the table

  Scenario: Add product with very long description
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Detailed Product"
    And I fill in the product description with a 1000 character string
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the description should be truncated in the table view

  Scenario: Add product with special characters in name
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Smart Watch™ 2.0 (Premium) $$$"
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product name should be properly escaped and displayed

  Scenario: Add product with decimal price
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Budget Item"
    And I fill in the product price with "9.99"
    And I submit the product form
    Then I should see a success message "Product added successfully!"
    And the product should display price "$9.99"

  Scenario: Add multiple products sequentially
    When I add 5 different products to the inventory
    Then all 5 products should appear in the inventory table
    And each product should have a unique ID

  # Error Scenarios
  Scenario: Attempt to add product without name
    When I click the "ADD PRODUCT" button
    And I leave the product name field empty
    And I submit the product form
    Then I should see an error message "Product name is required"
    And the product should not be added to the inventory

  Scenario: Attempt to edit non-existent product
    Given no products exist in the system
    When I attempt to edit a product with invalid ID "invalid-uuid"
    Then I should see an error message "Failed to fetch product details"

  Scenario: Cancel product creation
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Cancelled Product"
    And I click the "CANCEL" button
    Then the product modal should close
    And no new product should be added to the inventory

  Scenario: Cancel product deletion
    Given a product exists with name "Protected Item"
    When I click the "DELETE" button for product "Protected Item"
    And I cancel the deletion in the dialog
    Then the product "Protected Item" should remain in the inventory table

  Scenario: Close modal without saving
    When I click the "ADD PRODUCT" button
    And I fill in the product name with "Unsaved Product"
    And I click the close button (×) on the modal
    Then the product modal should close
    And no new product should be added to the inventory

  # Accessibility Scenarios
  Scenario: Navigate product form using keyboard only
    When I press Tab to focus on the "ADD PRODUCT" button
    And I press Enter to open the product modal
    And I use Tab to navigate through all form fields
    And I fill in all required fields using keyboard
    And I press Tab to reach the submit button
    And I press Enter to submit the form
    Then the product should be successfully added
    And I should receive keyboard-accessible success feedback

  Scenario: Product form has proper ARIA labels
    When I click the "ADD PRODUCT" button
    Then the product name field should have aria-required="true"
    And the product description field should have aria-label="Product description"
    And the price field should have aria-label="Product price"
    And the category dropdown should have aria-label="Product category"
    And the close button should have aria-label="Close modal"

  Scenario: Success alerts are announced to screen readers
    When I successfully add a product
    Then the success message should have role="alert"
    And the message should be announced to screen readers

  Scenario: Table has proper structure for screen readers
    Given multiple products exist in the inventory
    When I navigate to the product management page
    Then the inventory table should have proper thead and tbody elements
    And each column header should describe its content
    And action buttons should have aria-labels describing the action and product name

  Scenario: Search input is accessible
    When I navigate to the product management page
    Then the search input should have aria-label="Search products"
    And the category filter should have aria-label="Filter by category"
