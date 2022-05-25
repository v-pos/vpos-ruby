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
gem 'vpos', '~> 2.0.0'
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
vpos = Vpos.new

# or use optional arguments option
vpos = Vpos.new(token: 'your_token_here')
```

#### Environment variables
| Variable | Description | Required |
| --- | --- | --- |
| `GPO_POS_ID` | The Point of Sale ID provided by EMIS | true |
| `MERCHANT_VPOS_TOKEN` | The API token provided by vPOS | true |
| `PAYMENT_CALLBACK_URL` | The URL that will handle payment notifications | false |
| `REFUND_CALLBACK_URL` | The URL that will handle refund notifications | false |

or using one of the optional arguments

#### Optional Arguments
| Argument | Description | Type |
| --- | --- | --- |
| `token` | Token generated at [vPOS](https://merchant.vpos.ao) dashboard | `string`
| `pos_id` | Merchant POS ID provided by EMIS | `string`
| `payment_callback_url` | Merchant application JSON endpoint to accept the callback payment response | `string`
| `refund_callback_url` | Merchant application JSON endpoint to accept the callback refund response | `string`

### Get a specific Transaction
Retrieves a transaction given a valid transaction ID using a env variable token.

```ruby
transaction = merchant.get_transaction(transaction_id: '1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

or

Using a explicitly stated token

```ruby
transaction = merchant.get_transaction(transaction_id: '1jHbXEbRTIbbwaoJ6w06nLcRG7X', token: 'EbRTIbb1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type | Required |
| --- | --- | --- |
| `transaction_id` | An existing Transaction ID | `string` | Yes |
| `token` | Merchant token generated at vPOS merchant portal | `string` | No (if set as env variable) |

### New Payment Transaction
Creates a new payment transaction given a valid mobile number associated with a `MULTICAIXA` account
and a valid amount using a env variable token.

```ruby
payment = merchant.new_payment(customer: '900111222', amount: '123.45')
```

or

Using a explicitly stated token

```ruby
payment = merchant.new_payment(customer: '900111222', amount: '123.45', token: 'EbRTIbb1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type | Required |
| --- | --- | --- |
| `customer` | The mobile number of the client who will pay | `string` | Yes |
| `amount` | The amount the client should pay, eg. "259.99", "259000.00" | `string` | Yes |
| `token` | Merchant token generated at vPOS merchant portal | `string` | No (if set as env variable) |
| `callback_url` | A valid https url where vPOS is going to callback as soon he finishes to process | `string` | No |

### Request Refund
Given an existing `parent_transaction_id`, request a refund using a env variable token.

```ruby
refund = merchant.new_refund(parent_transaction_id: '1kTFGhJH8i58uD9MdJpMjWnoE')
```

or

Using a explicitly stated token

```ruby
refund = merchant.new_refund(parent_transaction_id: '1kTFGhJH8i58uD9MdJpMjWnoE', token: 'EbRTIbb1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type | Required |
| --- | --- | --- |
| `parent_transaction_id` | The ID of transaction you wish to refund | `string`
| `token` | Merchant token generated at vPOS merchant portal | `string` | No (if set as env variable) |
| `callback_url` | A valid https url where vPOS is going to callback as soon he finishes to process | `string` | No |

### Poll Transaction Status
Poll the status of a transaction given a valid `request_id` using a env variable token. 

Note: The `request_id` in this context is essentially the `transaction_id` of an existing request. 

```ruby
transaction = merchant.get_request(request_id: '1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

or

Using a explicitly stated token

```ruby
transaction = merchant.get_request(request_id: '1jHbXEbRTIbbwaoJ6w06nLcRG7X', token: 'EbRTIbb1jHbXEbRTIbbwaoJ6w06nLcRG7X')
```

| Argument | Description | Type | Required? |
| --- | --- | --- |
| `request_id` | The ID of transaction you wish to poll | `string` | Yes |
| `token` | Merchant token generated at vPOS merchant portal | `string` | No (if set as env variable) |

### Have any doubts?
In case of any doubts, bugs, or the like, please leave an issue. We would love to help.

License
----------------

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
