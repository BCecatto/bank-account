# README

System to manage a bank account with JWT authentication.
  
* Ruby version
  `2.6.2`

* bundler version
  `1.17.2`

## Project setup
  `bin/setup`

## How to run the test suite
  `rspec spec`

## How to run quality of code verification
  `rubocop`

## Docker
  `pending`

## Architecture
  To save the history of transaction of a user was created table event, this table have a column to save value of balance of account, this way I can guarantee idepodent of all, and dont need to sum all events to get the balance, I can do this easily looking to your last event of account, and if some problemn happen can verify the value run a query to sum all events. When user is created trigger a creation of a new account and the first event of deposit of him account, and I prefer this way to avoid use callback in model, so because of it I create two function one name withdrawal and other deposit and I trigger it in a service, I utilize transaction to avoid some error of one operation happen and other not. Follow the documentation I put the option to utilize to send source_account_id in params, but because of token JWT I can get current_user in any controller.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
