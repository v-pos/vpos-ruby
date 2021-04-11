# vPOS Ruby
[![Ruby](https://github.com/v-pos/vpos-ruby/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/v-pos/vpos-ruby/actions/workflows/ruby.yml)
[![Gem Version](https://badge.fury.io/rb/vpos.svg)](https://badge.fury.io/rb/vpos)
[![](https://img.shields.io/badge/vPOS-OpenSource-blue.svg)](https://www.nextbss.co.ao)

This ruby library helps you easily interact with the vPOS API,
Allowing merchants apps/services to request a payment from a client through his/her mobile phone number.

The service currently works for solutions listed below:

- EMIS GPO (Multicaixa Express)

Want to know more about how we are empowering merchants in Angola? See our [website](https://vpos.ao)

### Features
- Simple interface
- Uniform plain old objects are returned by all official libraries, so you don't have
to serialize/deserialize the JSON returned by our API.

### Documentation
Does interacting directly with our API service sound better to you? 
See our documentation on [developer.vpos.ao](https://developer.vpos.ao)

## Installation
```ruby
gem 'vpos', '~> 1.0.0'
```

or 

```ruby
gem install vpos
```

### Configuration
This ruby library requires you to have:
- POS_ID provided by EMIS that can be requested through your support bank.
- Supervisor Card provided by EMIS that can be requested through your support bank.
- Token provided by vPOS that can be generated through vPOS [merchant](https://merchant.vpos.ao) portal.

Don't have this information? [Talk to us](suporte@vpos.ao)

Given you have all the requirements above, you will now
be able to authenticate and communicate effectively with our API using this library. 

The next section will show the various actions that can be performed by you, the merchant.

## Use
### Create Instance

```ruby
require 'vpos'

# use the default environment variables option
merchant = Vpos.new

# or use optional arguments option
merchant = Vpos.new(token: 'your_token_here', environment: 'PRD')
```

#### Environment variables
| Variable | Description | Required |
| --- | --- | --- |
| `GPO_POS_ID` | The Point of Sale ID provided by EMIS | true |
| `GPO_SUPERVISOR_CARD` | The Supervisor card ID provided by EMIS | true |
| `MERCHANT_VPOS_TOKEN` | The API token provided by vPOS | true |
| `PAYMENT_CALLBACK_URL` | The URL that will handle payment notifications | false |
| `REFUND_CALLBACK_URL` | The URL that will handle refund notifications | false |

or using one of the optional arguments

#### Optional Arguments
| Argument | Description | Type |
| --- | --- | --- |
| `token` | Token generated at [vPOS](https://merchant.vpos.ao) dashboard | `string`
| `pos_id` | Merchant POS ID provided by EMIS | `string`
| `supervisor_card` | Merchant Supervisor Card number provided by EMIS | `string`
| `payment_callback_url` | Merchant application JSON endpoint to accept the callback payment response | `string`
| `refund_callback_url` | Merchant application JSON endpoint to accept the callback refund response | `string`
| `environment` | The vPOS environment, leave empty for `sandbox` mode and use `"PRD"` for `production`.  | `string` |

### Get all Transactions
This endpoint retrieves all transactions.

```ruby
transaction = merchant.get_transactions
```

### Get a specific Transaction
Retrieves a transaction given a valid transaction ID.

```ruby
transaction = merchant.get_transaction('1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type |
| --- | --- | --- |
| `id` | An existing Transaction ID | `string`

### New Payment Transaction
Creates a new payment transaction given a valid mobile number associated with a `MULTICAIXA` account
and a valid amount.

```ruby
payment = merchant.new_payment('900111222', '123.45')
```

| Argument | Description | Type |
| --- | --- | --- |
| `mobile` | The mobile number of the client who will pay | `string`
| `amount` | The amount the client should pay, eg. "259.99", "259000.00" | `string`

### Request Refund
Given an existing `parent_transaction_id`, request a refund.

```ruby
refund = merchant.new_refund('1kTFGhJH8i58uD9MdJpMjWnoE')
```

| Argument | Description | Type |
| --- | --- | --- |
| `parent_transaction_id` | The ID of transaction you wish to refund | `string`

### Poll Transaction Status
Poll the status of a transaction given a valid `request_id`. 

Note: The `request_id` in this context is essentially the `transaction_id` of an existing request. 

```ruby
transaction = merchant.get_request('1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type |
| --- | --- | --- |
| `request_id` | The ID of transaction you wish to poll | `string`

### Have any doubts?
In case of any doubts, bugs, or the like, please leave an issue. We would love to help.

License
----------------

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
