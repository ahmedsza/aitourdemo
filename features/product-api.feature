Feature: Product API Endpoints
  As a client application
  I want to interact with the Product API
  So that I can perform CRUD operations on products

  Background:
    Given the Flask API server is running at "http://localhost:5000"
    And the product database is empty

  # Happy Path - Create Product
  Scenario: Create a new product with all fields
    When I send a POST request to "/products" with:
      """
      {
        "name": "Laptop Pro",
        "description": "High-performance laptop for professionals",
        "price": 1299.99,
        "category": "Electronics"
      }
      """
    Then the response status code should be 201
    And the response should contain a product ID
    And the response should contain:
      | field       | value                                      |
      | name        | Laptop Pro                                 |
      | description | High-performance laptop for professionals  |
      | price       | 1299.99                                    |
      | category    | Electronics                                |

  Scenario: Create a product with only required fields
    When I send a POST request to "/products" with:
      """
      {
        "name": "Simple Product"
      }
      """
    Then the response status code should be 201
    And the response should contain:
      | field       | value           |
      | name        | Simple Product  |
      | description |                 |
      | price       | 0               |
      | category    | General         |

  # Happy Path - Read Products
  Scenario: Get all products when database is empty
    When I send a GET request to "/products"
    Then the response status code should be 200
    And the response should be an empty array

  Scenario: Get all products with multiple products
    Given the following products exist:
      | name              | price  | category    |
      | Product A         | 10.00  | Electronics |
      | Product B         | 20.00  | Sports      |
      | Product C         | 30.00  | Books       |
    When I send a GET request to "/products"
    Then the response status code should be 200
    And the response should be an array with 3 items
    And the response should contain all product details

  Scenario: Get a specific product by ID
    Given a product exists with:
      | name        | Specific Item  |
      | price       | 99.99          |
      | category    | General        |
    When I send a GET request to "/products/{product_id}"
    Then the response status code should be 200
    And the response should contain:
      | field    | value          |
      | name     | Specific Item  |
      | price    | 99.99          |
      | category | General        |

  # Happy Path - Update Product
  Scenario: Update all fields of an existing product
    Given a product exists with name "Original Name"
    When I send a PUT request to "/products/{product_id}" with:
      """
      {
        "name": "Updated Name",
        "description": "Updated description",
        "price": 199.99,
        "category": "Updated Category"
      }
      """
    Then the response status code should be 200
    And the response should contain:
      | field       | value                |
      | name        | Updated Name         |
      | description | Updated description  |
      | price       | 199.99               |
      | category    | Updated Category     |

  Scenario: Update only the name of a product
    Given a product exists with:
      | name        | Old Name  |
      | description | Original  |
      | price       | 50.00     |
    When I send a PUT request to "/products/{product_id}" with:
      """
      {
        "name": "New Name",
        "description": "Original",
        "price": 50.00
      }
      """
    Then the response status code should be 200
    And the product name should be "New Name"

  # Happy Path - Delete Product
  Scenario: Delete an existing product
    Given a product exists with name "Product to Delete"
    When I send a DELETE request to "/products/{product_id}"
    Then the response status code should be 204
    And the response body should be empty
    When I send a GET request to "/products/{product_id}"
    Then the response status code should be 404

  # Error Scenarios - Create
  Scenario: Create product without required name field
    When I send a POST request to "/products" with:
      """
      {
        "description": "Product without name",
        "price": 100
      }
      """
    Then the response status code should be 400

  Scenario: Create product with empty request body
    When I send a POST request to "/products" with empty body
    Then the response status code should be 400

  Scenario: Create product with null name
    When I send a POST request to "/products" with:
      """
      {
        "name": null,
        "price": 50
      }
      """
    Then the response status code should be 400

  Scenario: Create product with invalid JSON
    When I send a POST request to "/products" with invalid JSON:
      """
      {"name": "Invalid JSON"
      """
    Then the response status code should be 400

  # Error Scenarios - Read
  Scenario: Get product with non-existent ID
    When I send a GET request to "/products/non-existent-id"
    Then the response status code should be 404

  Scenario: Get product with invalid UUID format
    When I send a GET request to "/products/invalid-uuid-format"
    Then the response status code should be 404

  # Error Scenarios - Update
  Scenario: Update non-existent product
    When I send a PUT request to "/products/non-existent-id" with:
      """
      {
        "name": "Updated Name",
        "price": 100
      }
      """
    Then the response status code should be 404

  Scenario: Update product without required name field
    Given a product exists with name "Existing Product"
    When I send a PUT request to "/products/{product_id}" with:
      """
      {
        "description": "Missing name field"
      }
      """
    Then the response status code should be 400

  Scenario: Update product with empty request body
    Given a product exists with name "Existing Product"
    When I send a PUT request to "/products/{product_id}" with empty body
    Then the response status code should be 400

  # Error Scenarios - Delete
  Scenario: Delete non-existent product
    When I send a DELETE request to "/products/non-existent-id"
    Then the response status code should be 404

  Scenario: Delete already deleted product
    Given a product exists with name "Product to Delete"
    And the product has been deleted
    When I send a DELETE request to "/products/{product_id}"
    Then the response status code should be 404

  # Edge Cases
  Scenario: Create product with very long name
    When I send a POST request to "/products" with a name of 1000 characters
    Then the response status code should be 201
    And the product name should be stored correctly

  Scenario: Create product with special characters in name
    When I send a POST request to "/products" with:
      """
      {
        "name": "Product™ <Test> & \"Special\" 'Characters' 中文"
      }
      """
    Then the response status code should be 201
    And the product name should be properly encoded

  Scenario: Create product with negative price
    When I send a POST request to "/products" with:
      """
      {
        "name": "Negative Price Product",
        "price": -50.00
      }
      """
    Then the response status code should be 201
    And the price should be stored as -50.00

  Scenario: Create product with zero price
    When I send a POST request to "/products" with:
      """
      {
        "name": "Free Item",
        "price": 0
      }
      """
    Then the response status code should be 201
    And the price should be 0

  Scenario: Create product with very large price
    When I send a POST request to "/products" with:
      """
      {
        "name": "Expensive Item",
        "price": 999999999.99
      }
      """
    Then the response status code should be 201
    And the price should be stored correctly

  Scenario: Create multiple products with same name
    When I create 3 products all named "Duplicate Product"
    Then all 3 products should be created successfully
    And each should have a unique ID

  Scenario: Update product multiple times in succession
    Given a product exists with name "Original"
    When I update the product 5 times sequentially
    Then each update should succeed with status 200
    And the final state should reflect the last update

  # Content-Type and Headers
  Scenario: Create product without Content-Type header
    When I send a POST request to "/products" without Content-Type header
    Then the response status code should be 400 or 415

  Scenario: API accepts JSON with different content types
    When I send a POST request with Content-Type "application/json; charset=utf-8"
    And the body contains valid product data
    Then the response status code should be 201

  Scenario: CORS headers are present
    When I send an OPTIONS request to "/products"
    Then the response should include CORS headers
    And Access-Control-Allow-Origin should be present

  # Concurrent Operations
  Scenario: Create multiple products concurrently
    When I send 10 concurrent POST requests to create products
    Then all 10 products should be created successfully
    And each should have a unique ID

  Scenario: Update same product concurrently
    Given a product exists with name "Concurrent Test"
    When I send 5 concurrent PUT requests to update the product
    Then all updates should complete
    And the product should be in a valid state

  # Performance
  Scenario: API responds quickly for GET all products
    Given 100 products exist in the system
    When I send a GET request to "/products"
    Then the response should be received within 1 second
    And all 100 products should be returned

  Scenario: API handles large product description
    When I send a POST request with a 10000 character description
    Then the response status code should be 201
    And the full description should be stored
