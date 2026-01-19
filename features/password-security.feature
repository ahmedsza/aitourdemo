Feature: Password Security Utilities
  As a developer using the utils module
  I want to validate and hash passwords securely
  So that I can maintain secure authentication in the application

  Background:
    Given the utils module is imported
    And the password security functions are available

  # Password Strength Validation - Happy Path
  Scenario: Validate strong password with all requirements
    When I check if "SecureP@ss123" is a strong password
    Then the result should be True

  Scenario: Validate password with minimum 8 characters and all types
    When I check if "Abcd123!" is a strong password
    Then the result should be True

  Scenario: Validate password with multiple special characters
    When I check if "P@ssw0rd!#$" is a strong password
    Then the result should be True

  Scenario: Validate longer strong password
    When I check if "MyVeryS3cure!Password" is a strong password
    Then the result should be True

  # Password Strength Validation - Error Scenarios
  Scenario: Reject password shorter than 8 characters
    When I check if "Pas1!" is a strong password
    Then the result should be False

  Scenario: Reject password without uppercase letters
    When I check if "password123!" is a strong password
    Then the result should be False

  Scenario: Reject password without lowercase letters
    When I check if "PASSWORD123!" is a strong password
    Then the result should be False

  Scenario: Reject password without numbers
    When I check if "Password!" is a strong password
    Then the result should be False

  Scenario: Reject password without special characters
    When I check if "Password123" is a strong password
    Then the result should be False

  Scenario: Reject password with only letters
    When I check if "PasswordOnly" is a strong password
    Then the result should be False

  Scenario: Reject password with only numbers
    When I check if "12345678" is a strong password
    Then the result should be False

  Scenario: Reject empty password
    When I check if "" is a strong password
    Then the result should be False

  Scenario: Reject password with exactly 7 characters
    When I check if "Pass1!" is a strong password
    Then the result should be False

  Scenario Outline: Validate password strength for various inputs
    When I check if "<password>" is a strong password
    Then the result should be <expected>

    Examples:
      | password           | expected |
      | Str0ng!Pass        | True     |
      | WeakPassword       | False    |
      | 12345678           | False    |
      | NoDigits!          | False    |
      | nouppercas3!       | False    |
      | NOLOWERCASE1!      | False    |
      | NoSpecial123       | False    |
      | Short1!            | False    |
      | MyP@ssw0rd         | True     |

  # Password Hashing - Happy Path
  Scenario: Hash a valid password
    When I hash the password "MySecurePassword123!"
    Then the result should be a SHA-256 hash
    And the hash should be 64 characters long
    And the hash should be hexadecimal

  Scenario: Hash returns consistent result
    When I hash the password "SamePassword123!" twice
    Then both hashes should be identical

  Scenario: Different passwords produce different hashes
    When I hash the password "Password1!"
    And I hash the password "Password2!"
    Then the hashes should be different

  Scenario: Hash is deterministic
    When I hash the password "DeterministicP@ss1" multiple times
    Then all hashes should be identical

  # Password Hashing - Edge Cases
  Scenario: Hash empty password
    When I hash the password ""
    Then the result should be a valid SHA-256 hash

  Scenario: Hash very long password
    When I hash a password with 1000 characters
    Then the result should be a valid SHA-256 hash
    And the hash should be 64 characters long

  Scenario: Hash password with special characters
    When I hash the password "P@ssw0rd!#$%^&*()"
    Then the result should be a valid SHA-256 hash

  Scenario: Hash password with Unicode characters
    When I hash the password "Pässwörd123!中文"
    Then the result should be a valid SHA-256 hash

  Scenario: Hash password with whitespace
    When I hash the password "My Pass Word 123!"
    Then the result should be a valid SHA-256 hash

  Scenario: Hash password with newlines
    When I hash the password "Pass\nword123!"
    Then the result should be a valid SHA-256 hash

  Scenario: Hash password with tabs
    When I hash the password "Pass\tword123!"
    Then the result should be a valid SHA-256 hash

  # Security Properties
  Scenario: Hash is irreversible
    Given I have hashed the password "SecretP@ss123"
    When I attempt to reverse the hash
    Then it should be computationally infeasible

  Scenario: Hash does not contain original password
    When I hash the password "MyPassword123!"
    Then the hash should not contain the original password text

  Scenario: Hash is case-sensitive
    When I hash the password "Password123!"
    And I hash the password "password123!"
    Then the hashes should be different

  Scenario: Small password changes produce different hashes
    When I hash the password "Password123!"
    And I hash the password "Password123!!"
    Then the hashes should be completely different

  # Combined Validation and Hashing
  Scenario: Validate and hash a strong password
    Given the password "Str0ng!Password"
    When I validate the password strength
    Then the password should be strong
    When I hash the password
    Then the hash should be valid

  Scenario: Attempt to hash weak password
    Given the password "weak"
    When I check the password strength
    Then the password should be weak
    But I can still hash it if needed
    And the hash should be valid

  # Performance
  Scenario: Password validation is fast
    When I validate 1000 passwords
    Then the operation should complete within 1 second

  Scenario: Password hashing is reasonably fast
    When I hash 100 passwords
    Then the operation should complete within 5 seconds

  # Boundary Cases
  Scenario: Validate password with exactly 8 characters
    When I check if "Pass123!" is a strong password
    Then the result should be True

  Scenario: Validate password with 50 characters
    When I check if "VeryLongButStrongPassword123!@#$%WithManyChars" is a strong password
    Then the result should be True

  Scenario: Hash with minimum requirements
    Given a password with exactly 8 characters, 1 uppercase, 1 lowercase, 1 digit, 1 special
    When I validate and hash the password
    Then validation should pass
    And hash should be valid

  # Error Handling
  Scenario: Handle None input for validation
    When I check if None is a strong password
    Then the function should raise a TypeError or AttributeError
    # Note: Current implementation doesn't handle None gracefully

  Scenario: Handle None input for hashing
    When I attempt to hash None as a password
    Then the function should raise an AttributeError
    # Note: Current implementation will fail on None.encode()

  Scenario: Handle integer input for validation
    When I check if 12345678 is a strong password
    Then the result should be False

  # Security Best Practices
  Scenario: Hash uses secure algorithm
    When I examine the hashing function
    Then it should use SHA-256 or stronger
    And it should not use MD5 or SHA-1

  Scenario: Password validation enforces complexity
    When I check the password validation rules
    Then it should require at least 8 characters
    And it should require uppercase letters
    And it should require lowercase letters
    And it should require numbers
    And it should require special characters

  Scenario: Same password hashed multiple times gives same hash
    When I hash "TestPassword123!" five times
    Then all five hashes should be identical
    And this demonstrates hash determinism for authentication

  Scenario: Hashing is idempotent
    Given a password "IdempotentP@ss1"
    When I hash it once and store the result
    And I hash it again
    Then both results should match exactly
