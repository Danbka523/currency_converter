# CurrencyConverter

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/currency_converter`. To experiment with that code, run `bin/console` for an interactive prompt.

This gem is used for parsing API of the Central Bank of the Russian Federation.\
Specifically, the following APIs are used: \
1."Foreign Currency Market" API \
2."Foreign Currency Market Dynamic" API \
3."Credit institutions balances on correspondent accounts with Bank of Russia"  API \
4."Precious metals quotations" API \
5."Interbank Credit Market" API \
6."Deposit rates in the money market" API \
7."Server news" API \
8."List of credit institutions" API \
9."Swap buy-sell overnight" API \
10."Release Prices of the Bank of Russia for Investment Coins" API \
11."List of companies with identified signs of illegal activity in the financial market" API \

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add currency_converter

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install currency_converter

## Usage

To use the gem's functionality, you need to write the name of the method and, as parameters, specify the time period that is checked for correctness.
In some methods, for example, "biс" , "news" , "blist" parameters are not needed. In the "get_daily_cur" , "get_dynamic_cur" methods you can specify the currency and in the "get_metal_info" method you can specify the name of the metal to get specific information.
Signatures of all methods:
1.def get_daily_cur(date="",currency="")
2.def get_dynamic_cur(date1,date2,currency)
3.def get_remains(date1, date2)
4.def news()
5.def bic()
6.def currency_swap(date1,date2)
7.def coinsbase(date1, date1)
8.def get_metal_info(date1,date2,name_of_metal="")
9.def get_deposit_rates(date1,date2)
10.def get_credit_market_info(date1,date2)
11.def blist()

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Danbka523/currency_converter.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
