# Vpos Ruby

[![Build Status](https://dev.azure.com/next-solutions/vpos/_apis/build/status/vpos%20-%20sdk%20-%20ruby?branchName=main)](https://dev.azure.com/next-solutions/vpos/_build/latest?definitionId=75&branchName=main)
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

### Configuration
This ruby library requires you set up the following environment variables on your machine before
interacting with the API using this library:

| Variable | Description
| --- | --- | 
| `GPO_POS_ID` | The Point of Sale ID provided by EMIS |
| `GPO_SUPERVISOR_CARD` | The Supervisor card ID provided by EMIS |
| `MERCHANT_VPOS_TOKEN` | The API token provided by vPOS |
| `PAYMENT_CALLBACK_URL` | The URL that will handle payment notifications |
| `REFUND_CALLBACK_URL` | The URL that will handle refund notifications |
| `VPOS_ENVIRONMENT` | The vPOS environment, leave empty for `sandbox` mode and use `"prd"` for `production`.  |

Don't have this information? [Talk to us](suporte@vpos.ao)

Given you have set up all the environment variables above with the correct information, you will now
be able to authenticate and communicate effectively with our API using this library. 

The next section will show the various payment actions that can be performed by you, the merchant.

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

| Argument | Description | Type |
| --- | --- | --- |
| `id` | An existing Transaction ID | `string`

### New Payment Transaction
Creates a new payment transaction given a valid mobile number associated with a `MULTICAIXA` account
and a valid amount.

```ruby
require 'vpos'
payment = Vpos.new_payment("900111222", "123.45")
```

| Argument | Description | Type |
| --- | --- | --- |
| `mobile` | The mobile number of the client who will pay | `string`
| `amount` | The amount the client should pay, eg. "259.99", "259,000.00" | `string`

### Request Refund
Given an existing `parent_transaction_id`, request a refund.

```ruby
require 'vpos'

refund = Vpos.new_refund("1kTFGhJH8i58uD9MdJpMjWnoE")
```

| Argument | Description | Type |
| --- | --- | --- |
| `parent_transaction_id` | The ID of transaction you wish to refund | `string`

### Have any doubts?
In case of any doubts, bugs, or the like, please leave an issue. We would love to help.

License
----------------
TODO