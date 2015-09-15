# tmoney

A simple client for [T-money](https://www.t-money.co.kr/).

## How to use

The following is the example which demonstrates how to use T-money client. To test this code, you need to change `<USERNAME>` and `<PASSWORD>` to your own username and password.
```ruby
require 'tmoney'

client = Tmoney::Client.new
client.connect('<USERNAME>', '<PASSWORD>')
cards = client.cards
puts '== My Cards', cards
puts '== Transactions', cards[0].transactions
```

It will produce the following output:
```
== My Cards
티머니 0000-0000-0000-0000 2015-09-15
== Transactions
2015-09-13 19:25:39 지하철 서울메트로(2호선) 1050
2015-09-13 20:51:06 택시 택시 3400
2015-09-15 21:44:55 충전 1호선 서울역 50000
```
