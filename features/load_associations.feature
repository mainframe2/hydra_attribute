Feature: hydra attribute associations
  When loaded collection has more than one record
  Then all hydra attribute associations should be loaded

  When loaded collection hasn't records or has only one
  Then hydra attribute association should not be loaded automatically

  When records were loaded via base class and total of records are more than one
  Then all records should have loaded hydra attribute associations which are described in class

  Background: create models and describe hydra attributes
    Given removed constants if they exist:
      | name          |
      | GroupProduct  |
      | SimpleProduct |
      | Product       |
    And create model class "Product"
    And create model class "SimpleProduct" as "Product" with hydra attributes:
      | type   | name  |
      | string | code  |
      | float  | price |
    And create model class "GroupProduct" as "Product" with hydra attributes:
      | type    | name   |
      | float   | price  |
      | string  | title  |
      | boolean | active |

  Scenario: hydra attribute associations should be included for collection with more then one record
    Given create models:
      | model         | attributes |
      | SimpleProduct | code=1     |
      | SimpleProduct | code=2     |
    When load all "SimpleProduct" records
    Then records "should" have loaded associations:
      | association             |
      | hydra_string_attributes |
      | hydra_float_attributes  |

  Scenario: hydra attribute associations should not be included for collection with one record
    Given create models:
      | model        | attributes |
      | GroupProduct | price=2.75 |
    When load all "GroupProduct" records
    Then records "should_not" have loaded associations:
      | association              |
      | hydra_float_attributes   |
      | hydra_string_attributes  |
      | hydra_boolean_attributes |

  Scenario: all hydra attribute associations should be included if we load records from base class
    Given create models:
      | model         | attributes |
      | SimpleProduct | code=1     |
      | GroupProduct  | price=7    |
    When load all "Product" records
    Then "SimpleProduct" records "should" have loaded associations:
      | association             |
      | hydra_string_attributes |
      | hydra_float_attributes  |
    And "GroupProduct" records "should" have loaded associations:
      | association              |
      | hydra_float_attributes   |
      | hydra_string_attributes  |
      | hydra_boolean_attributes |
