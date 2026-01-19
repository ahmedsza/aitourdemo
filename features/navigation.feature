Feature: Navigation and Page Transitions
  As a user
  I want to navigate between different pages of the application
  So that I can access different features and sections

  Background:
    Given the ZAVA Backoffice application is running

  # Happy Path Scenarios
  Scenario: Navigate to home page
    Given I am on any page
    When I click on "HOME" in the navigation menu
    Then I should be on the home page
    And I should see "BACKOFFICE MANAGEMENT PORTAL" heading
    And the HOME navigation link should be highlighted

  Scenario: Navigate to about page
    Given I am on the home page
    When I click on "ABOUT" in the navigation menu
    Then I should be on the about page
    And I should see "ABOUT ZAVA" heading
    And the ABOUT navigation link should be highlighted

  Scenario: Navigate to products page
    Given I am on the home page
    When I click on "PRODUCTS" in the navigation menu
    Then I should be on the product management page
    And I should see "PRODUCT MANAGEMENT" heading
    And the PRODUCTS navigation link should be highlighted

  Scenario: Navigate to stores page
    Given I am on the home page
    When I click on "STORES" in the navigation menu
    Then I should be on the stores page
    And I should see "STORE FINDER" heading
    And I should see "COMING SOON" message

  Scenario: Navigate to contact page
    Given I am on the home page
    When I click on "CONTACT" in the navigation menu
    Then I should be on the contact page
    And I should see "CONTACT US" heading
    And I should see "COMING SOON" message

  Scenario: Navigate from products to home
    Given I am on the product management page
    When I click on "HOME" in the navigation menu
    Then I should be on the home page
    And the page should scroll to the top

  Scenario: Use hero CTA to navigate to products
    Given I am on the home page
    When I click the "MANAGE PRODUCTS" button in the hero section
    Then I should be navigated to the product management page

  Scenario: Use hero CTA to navigate to about
    Given I am on the home page
    When I click the "ABOUT SYSTEM" button in the hero section
    Then I should be navigated to the about page

  Scenario: Navigate using footer links
    Given I am on any page
    When I scroll to the footer
    And I click "About Us" in the footer
    Then I should be navigated to the about page

  Scenario: Navigate to products from footer
    Given I am on any page
    When I scroll to the footer
    And I click "Products" in the footer
    Then I should be navigated to the product management page

  Scenario: Navigate to products from home page featured section
    Given I am on the home page
    And featured products are displayed
    When I click "VIEW DETAILS" on any featured product
    Then I should be navigated to the product management page

  # Page Transition Behaviors
  Scenario: Page transition animation
    Given I am on the home page
    When I navigate to the about page
    Then the page should transition with a fade-in animation
    And the transition should complete within 1 second

  Scenario: Active page indicator updates
    Given I am on the home page
    When I navigate through all pages in sequence
    Then each page's navigation link should be highlighted when active
    And only one navigation link should be highlighted at a time

  Scenario: Page content loads correctly after navigation
    Given I am on the about page
    When I navigate to the products page
    Then the products page content should be fully loaded
    And product data should be fetched and displayed

  Scenario: Products load when navigating to products page
    Given I am on the home page
    And there are products in the system
    When I navigate to the products page
    Then the products should automatically load
    And the loading state should be displayed briefly

  Scenario: Featured products load on home page
    Given products exist in the system
    When I navigate to the home page
    Then up to 6 featured products should be displayed
    And each product should show name, price, and category

  # Edge Cases
  Scenario: Navigate to same page
    Given I am on the home page
    When I click on "HOME" in the navigation menu again
    Then I should remain on the home page
    And the page should scroll to the top

  Scenario: Rapid navigation between pages
    Given I am on the home page
    When I rapidly click through all navigation links
    Then each page should load correctly
    And no UI glitches should occur

  Scenario: Back button behavior
    Given I am on the home page
    And I navigate to the products page
    And I navigate to the about page
    When I click the browser back button
    Then the page state should be maintained correctly

  Scenario: Direct URL navigation
    Given I am viewing the application
    When I directly navigate to a specific section via URL hash
    Then the correct section should be displayed

  # Mobile Navigation
  Scenario: Open mobile navigation menu
    Given I am viewing the site on a mobile device
    When I tap the hamburger menu icon
    Then the mobile navigation menu should slide down
    And all navigation links should be visible

  Scenario: Close mobile menu after navigation
    Given I am viewing the site on a mobile device
    And the mobile menu is open
    When I tap on "PRODUCTS" in the mobile menu
    Then I should be navigated to the products page
    And the mobile menu should automatically close

  Scenario: Mobile menu toggle
    Given I am viewing the site on a mobile device
    When I tap the hamburger menu icon to open
    And I tap it again
    Then the mobile menu should close

  # Error Scenarios
  Scenario: Page section does not exist
    Given I am on the home page
    When the application attempts to show an invalid page
    Then the application should handle the error gracefully
    And should default to showing the home page

  Scenario: Products fail to load on navigation
    Given the API is unavailable
    When I navigate to the products page
    Then I should see an error message
    And the page structure should still be displayed correctly

  # Accessibility Scenarios
  Scenario: Keyboard navigation through menu
    Given I am on the home page
    When I press Tab repeatedly
    Then focus should move through navigation links in order
    And focused links should have visible focus indicators

  Scenario: Press Enter to navigate
    Given I am on the home page
    When I press Tab to focus the "ABOUT" link
    And I press Enter
    Then I should be navigated to the about page

  Scenario: Skip link for keyboard users
    Given I am on any page
    When I press Tab as the first action
    Then a skip link should be available for keyboard users
    And pressing Enter on the skip link should jump to main content

  Scenario: Navigation menu has proper ARIA roles
    When I inspect the navigation menu
    Then it should have role="navigation"
    And the menu toggle should have aria-label="Toggle menu"
    And the mobile menu should have proper ARIA states

  Scenario: Active page is indicated for screen readers
    Given I am on the products page
    When a screen reader reads the navigation menu
    Then the PRODUCTS link should be marked as current
    And should have aria-current="page" attribute

  Scenario: Page heading hierarchy
    Given I navigate to any page
    Then each page should have a single h1 heading
    And subheadings should follow proper hierarchy (h2, h3, etc.)
    And headings should describe the page content

  Scenario: Focus management on page transition
    Given I am on the home page
    When I navigate to the products page
    Then focus should be moved to the main content area
    And screen readers should announce the page change

  Scenario: Smooth scroll to top on navigation
    Given I am scrolled down on a page
    When I navigate to a different page
    Then the page should scroll to the top smoothly
    And the scroll should complete before content appears
