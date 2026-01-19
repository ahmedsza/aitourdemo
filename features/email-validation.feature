Feature: Email Validation Utility
  As a developer using the utils module
  I want to validate email addresses
  So that I can ensure data quality and prevent invalid email entries

  Background:
    Given the utils module is imported
    And the is_valid_email function is available

  # Happy Path Scenarios
  Scenario: Validate standard email address
    When I validate the email "user@example.com"
    Then the result should be True

  Scenario: Validate email with subdomain
    When I validate the email "user@mail.example.com"
    Then the result should be True

  Scenario: Validate email with plus sign
    When I validate the email "user+tag@example.com"
    Then the result should be True

  Scenario: Validate email with dots in username
    When I validate the email "user.name@example.com"
    Then the result should be True

  Scenario: Validate email with underscore
    When I validate the email "user_name@example.com"
    Then the result should be True

  Scenario: Validate email with hyphen
    When I validate the email "user-name@example.com"
    Then the result should be True

  Scenario: Validate email with numbers
    When I validate the email "user123@domain123.com"
    Then the result should be True

  Scenario: Validate short email address
    When I validate the email "u@d.co"
    Then the result should be True

  Scenario: Validate email with long TLD
    When I validate the email "user@example.travel"
    Then the result should be True

  Scenario Outline: Validate multiple valid email formats
    When I validate the email "<email>"
    Then the result should be True

    Examples:
      | email                              |
      | user@example.com                   |
      | user.name+tag@sub.domain.co        |
      | user_name@domain.org               |
      | user-name@domain.io                |
      | user123@domain123.com              |
      | u@d.co                             |
      | user.name@domain.travel            |
      | user@localhost.localdomain         |

  # Error Scenarios - Invalid Formats
  Scenario: Reject email without @ symbol
    When I validate the email "plainaddress"
    Then the result should be False

  Scenario: Reject email without username
    When I validate the email "@missingusername.com"
    Then the result should be False

  Scenario: Reject email without domain
    When I validate the email "username@"
    Then the result should be False

  Scenario: Reject email with missing domain name
    When I validate the email "username@.com"
    Then the result should be False

  Scenario: Reject email without TLD
    When I validate the email "username@domain"
    Then the result should be False

  Scenario: Reject email with only TLD
    When I validate the email "username@com"
    Then the result should be False

  Scenario: Reject email with double dots in domain
    When I validate the email "username@domain..com"
    Then the result should be False

  Scenario: Reject email with single character TLD
    When I validate the email "username@domain.c"
    Then the result should be False

  Scenario: Reject email with numeric TLD
    When I validate the email "username@domain.corporate1"
    Then the result should be False

  Scenario: Reject email with space in username
    When I validate the email "user name@domain.com"
    Then the result should be False

  Scenario: Reject email with comma instead of dot
    When I validate the email "user@domain,com"
    Then the result should be False

  Scenario: Reject email with dot at start of domain
    When I validate the email "user@.domain.com"
    Then the result should be False

  Scenario: Reject email with dot at end of domain
    When I validate the email "user@domain.com."
    Then the result should be False

  Scenario: Reject empty string
    When I validate the email ""
    Then the result should be False

  Scenario: Reject None value
    When I validate the email None
    Then the result should be False

  Scenario Outline: Reject multiple invalid email formats
    When I validate the email "<email>"
    Then the result should be False

    Examples:
      | email                    |
      | plainaddress             |
      | @missingusername.com     |
      | username@.com            |
      | username@com             |
      | username@domain..com     |
      | username@domain.c        |
      | username@domain.corporate1 |
      | user name@domain.com     |
      | user@domain,com          |
      | user@domain              |
      | user@.domain.com         |
      | user@domain.com.         |

  # Edge Cases
  Scenario: Validate email with maximum length username
    When I validate an email with 64 characters in the username part
    Then the result should be True

  Scenario: Validate email with maximum length domain
    When I validate an email with a 253 character domain
    Then the result should be True

  Scenario: Reject email with username exceeding maximum length
    When I validate an email with 65 characters in the username part
    Then the result should be False

  Scenario: Validate email with multiple subdomains
    When I validate the email "user@mail.dept.company.example.com"
    Then the result should be True

  Scenario: Validate email with uppercase characters
    When I validate the email "USER@EXAMPLE.COM"
    Then the result should be True

  Scenario: Validate email with mixed case
    When I validate the email "User@Example.Com"
    Then the result should be True

  Scenario: Reject email with special characters in domain
    When I validate the email "user@domain!.com"
    Then the result should be False

  Scenario: Reject email with multiple @ symbols
    When I validate the email "user@@example.com"
    Then the result should be False

  Scenario: Reject email with @ at the beginning
    When I validate the email "@user@example.com"
    Then the result should be False

  Scenario: Validate email with numbers in domain
    When I validate the email "user@123domain.com"
    Then the result should be True

  Scenario: Validate email with hyphen in domain
    When I validate the email "user@my-domain.com"
    Then the result should be True

  Scenario: Reject email starting with dot
    When I validate the email ".user@example.com"
    Then the result should be False

  Scenario: Reject email ending with dot before @
    When I validate the email "user.@example.com"
    Then the result should be False

  Scenario: Reject email with consecutive dots in username
    When I validate the email "user..name@example.com"
    Then the result should be False

  # Boundary Cases
  Scenario: Validate minimum valid email
    When I validate the email "a@b.co"
    Then the result should be True

  Scenario: Validate email with 2-character TLD
    When I validate the email "user@example.co"
    Then the result should be True

  Scenario: Validate email with 3-character TLD
    When I validate the email "user@example.com"
    Then the result should be True

  Scenario: Validate email with long TLD
    When I validate the email "user@example.museum"
    Then the result should be True

  # Security Cases
  Scenario: Reject email with SQL injection attempt
    When I validate the email "user'; DROP TABLE users--@example.com"
    Then the result should be False

  Scenario: Reject email with script injection attempt
    When I validate the email "user<script>@example.com"
    Then the result should be False

  Scenario: Reject email with null byte
    When I validate the email "user\x00@example.com"
    Then the result should be False

  # Type Handling
  Scenario: Handle integer input
    When I validate the email 12345
    Then the result should be False

  Scenario: Handle boolean input
    When I validate the email True
    Then the result should be False

  Scenario: Handle list input
    When I validate the email ["user@example.com"]
    Then the result should be False

  Scenario: Handle dictionary input
    When I validate the email {"email": "user@example.com"}
    Then the result should be False
