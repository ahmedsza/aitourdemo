# Gherkin Feature Files

This directory contains BDD (Behavior-Driven Development) feature files written in Gherkin syntax for the ZAVA Backoffice application.

## 📋 Overview

These feature files provide comprehensive test specifications for:
- **Frontend UI**: Product management, navigation, search/filter functionality
- **Backend API**: RESTful product CRUD operations
- **Utility Functions**: Email validation, password security

## 📁 Feature Files

| File | Scenarios | Description |
|------|-----------|-------------|
| `product-management.feature` | 22 | Complete product CRUD operations, UI interactions, form validation |
| `product-search-filter.feature` | 29 | Search functionality, category filtering, real-time updates |
| `navigation.feature` | 33 | Page transitions, menu navigation, mobile support |
| `product-api.feature` | 33 | REST API endpoints with comprehensive error handling |
| `email-validation.feature` | 51 | Email validation utility with edge cases and security |
| `password-security.feature` | 43 | Password strength validation and secure hashing |
| **Total** | **211** | **Complete application coverage** |

## 🎯 Coverage Breakdown

### By Category
- **Happy Path**: 54 scenarios (26%)
- **Edge Cases**: 45 scenarios (21%)
- **Error Handling**: 45 scenarios (21%)
- **Accessibility**: 21 scenarios (10%)
- **Security**: 14 scenarios (7%)
- **Performance**: 6 scenarios (3%)
- **API-Specific**: 7 scenarios (3%)

### By Feature Area
- **Frontend UI**: 82 scenarios (43%)
- **Backend API**: 41 scenarios (21%)
- **Utility Functions**: 69 scenarios (36%)

## 📖 Reading the Feature Files

### Gherkin Syntax
Feature files follow the standard Gherkin syntax:

```gherkin
Feature: [Feature Name]
  As a [role]
  I want to [action]
  So that [benefit]

  Background:
    Given [common precondition]

  Scenario: [Scenario Name]
    Given [precondition]
    When [action]
    Then [expected result]
    And [additional assertion]
```

### Example Scenario

```gherkin
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
```

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- Flask application running
- Test framework (pytest-bdd, behave, or similar)

### Recommended Test Frameworks

#### Option 1: pytest-bdd (Recommended for this project)
```bash
pip install pytest-bdd
```

#### Option 2: behave
```bash
pip install behave
```

### Running the Tests

```bash
# With pytest-bdd
pytest --bdd-features=features/

# With behave
behave features/
```

## 🔧 Implementation Guide

### Step 1: Choose Your Test Framework
- **pytest-bdd**: Integrates with existing pytest infrastructure
- **behave**: Standalone BDD framework

### Step 2: Create Step Definitions

For each feature file, create corresponding step definition files:

```
tests/
├── step_defs/
│   ├── test_product_management_steps.py
│   ├── test_product_search_steps.py
│   ├── test_navigation_steps.py
│   ├── test_product_api_steps.py
│   ├── test_email_validation_steps.py
│   └── test_password_security_steps.py
```

### Step 3: Example Step Definition (pytest-bdd)

```python
from pytest_bdd import scenarios, given, when, then

scenarios('../features/product-management.feature')

@given('I am on the product management page')
def navigate_to_products(browser):
    browser.get('http://localhost:5000')
    browser.find_element_by_link_text('PRODUCTS').click()

@when('I click the "ADD PRODUCT" button')
def click_add_product(browser):
    browser.find_element_by_text('+ ADD PRODUCT').click()

@then('I should see a success message "<message>"')
def verify_success_message(browser, message):
    alert = browser.find_element_by_role('alert')
    assert message in alert.text
```

### Step 4: Set Up Page Objects (for UI tests)

```python
class ProductManagementPage:
    def __init__(self, browser):
        self.browser = browser
    
    def click_add_product(self):
        self.browser.find_element_by_text('+ ADD PRODUCT').click()
    
    def fill_product_form(self, name, description, price, category):
        self.browser.find_element_by_id('productName').send_keys(name)
        self.browser.find_element_by_id('productDescription').send_keys(description)
        # ... etc
    
    def submit_form(self):
        self.browser.find_element_by_id('submitBtn').click()
```

## 🧪 Test Types by Feature

### Frontend UI Tests (Playwright/Selenium)
- `product-management.feature` - Requires browser automation
- `product-search-filter.feature` - Requires browser automation
- `navigation.feature` - Requires browser automation

### API Tests (Requests/HTTPx)
- `product-api.feature` - HTTP client testing

### Unit Tests (pytest)
- `email-validation.feature` - Already has tests in `test_utils.py`
- `password-security.feature` - Needs expanded unit tests

## ♿ Accessibility Testing

All UI feature files include accessibility scenarios:
- Keyboard navigation
- ARIA labels and roles
- Screen reader compatibility
- Focus management

### Example Accessibility Scenario
```gherkin
Scenario: Navigate product form using keyboard only
  When I press Tab to focus on the "ADD PRODUCT" button
  And I press Enter to open the product modal
  And I use Tab to navigate through all form fields
  Then all interactive elements should be keyboard accessible
  And focus indicators should be visible
```

## 🔒 Security Testing

Security scenarios included:
- Password complexity validation
- SHA-256 password hashing
- Email validation against injection
- XSS prevention
- API input validation

## 📊 Coverage Matrix

See [COVERAGE_MATRIX.md](./COVERAGE_MATRIX.md) for detailed coverage information including:
- Scenario distribution by category
- Coverage tables for each feature
- Implementation status
- Security and accessibility coverage

## 🎨 Feature File Organization

Each feature file follows this structure:

1. **Feature Header**: Role, goal, and benefit
2. **Background**: Common preconditions
3. **Happy Path Scenarios**: Primary user flows
4. **Edge Cases**: Boundary conditions
5. **Error Scenarios**: Negative testing
6. **Accessibility Scenarios**: A11y coverage
7. **Security/Performance Scenarios**: As applicable

## 📝 Writing New Scenarios

### Best Practices

✅ **DO**:
- Write in business language
- Make scenarios independent
- Use descriptive scenario names
- Include both positive and negative tests
- Add accessibility scenarios for UI features
- Use Background for common preconditions
- Use Scenario Outline for variations

❌ **DON'T**:
- Include implementation details
- Make scenarios dependent on execution order
- Use technical jargon
- Skip error scenarios
- Forget edge cases

### Template for New Scenarios

```gherkin
Scenario: [Clear, descriptive name]
  Given [precondition - the state before the action]
  And [additional precondition if needed]
  When [the action being tested]
  And [additional action if needed]
  Then [expected result - what should happen]
  And [additional verification]
  And [another verification]
```

## 🔄 Continuous Integration

### GitHub Actions Example

```yaml
name: BDD Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install pytest-bdd selenium
      - name: Run BDD tests
        run: pytest --bdd-features=features/
      - name: Generate report
        run: pytest --bdd-features=features/ --cucumber-json=report.json
```

## 📈 Reporting

Generate HTML reports with pytest:

```bash
pip install pytest-html
pytest --bdd-features=features/ --html=report.html
```

Generate Cucumber JSON reports:

```bash
pip install pytest-bdd-cucumber
pytest --bdd-features=features/ --cucumber-json=cucumber.json
```

## 🤝 Contributing

When adding new features to the application:

1. Write Gherkin scenarios first (BDD approach)
2. Review scenarios with stakeholders
3. Implement step definitions
4. Implement the feature
5. Run tests to verify
6. Update COVERAGE_MATRIX.md

## 📚 Resources

- [Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [pytest-bdd Documentation](https://pytest-bdd.readthedocs.io/)
- [Behave Documentation](https://behave.readthedocs.io/)
- [Playwright for Python](https://playwright.dev/python/)
- [WCAG Accessibility Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 📞 Support

For questions about the feature files or test implementation:
- Review the [COVERAGE_MATRIX.md](./COVERAGE_MATRIX.md) for detailed scenario information
- Check existing test implementations in `test_utils.py` for examples
- Refer to individual feature files for specific scenarios

---

**Last Updated**: 2026-01-19  
**Total Scenarios**: 211  
**Status**: ✅ Complete - Ready for step definition implementation
