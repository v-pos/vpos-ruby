# Vpos Ruby

![Ruby](https://github.com/nextbss/vpos-ruby/workflows/Ruby/badge.svg)
[![](https://img.shields.io/badge/nextbss-opensource-blue.svg)](https://www.nextbss.co.ao)

This ruby library helps you easily interact with the Vpos API,
Allowing merchants apps/services to request a payment from a client through his/her mobile phone number.

The service currently works for solutions listed below:

EMIS (Multicaixa Express)

### Documentation
Does interacting directly with our API service sound better to you? 
See our documentation on [developer.vpos.ao](https://developer.vpos.ao)

## Installation
```ruby
gem 'vpos'
```

### Usage
```ruby
 # TODO
```

### Get all Transactions
This endpoint retrieves all transactions.
```ruby
require 'vpos'
transactions = Vpos.get_transactions
```

### Get a specific Transaction
Retrieves a transaction given a valid transaction ID.
```ruby
require 'vpos'
transactions = Vpos.get_transaction("1jHbXEbRTIbbwaoJ6w06nLcRG7X")
```

### Have any doubts?
In case of any doubts, bugs, or the like, please leave an issue. We would love to help.

License
----------------
TODO