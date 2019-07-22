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

## Improvements
  - Estou logado, faz transferencia entre qualquer conta
  - setar amount como obrigatorio nos params
  - Melhorar os erros da API
  
## API routes

### /api/v1/users/create
```
this route create a new user with account and trigger the first event in your account.

params:

return:

```
### /api/v1/auth/login
```
this route create a JWT token to user with expiration time, to do this just have a user created in the route below and send the follow informations:

POST
params:
  email: string,
  password: string
  
return:
  token: string

CURL EXAMPLE:
  curl --location --request POST "localhost:3000/api/v1/auth/login?email=afton_durgan@gaylord.biz&password=321321" \
  --data ""
```

### /api/v1/transfer
```
this route is responsible to transfer a value from one account to another, source_account param is optional because of current_user.

POST
params: {
  source_account_id: source_account,
  destination_account_id: destination_account,
  amount: 50
}
header:
  ['Authorization'] = JWT
return:
  Transação cancelada ou Transação finalizada com sucesso.

CURL EXAMPLE:
curl --location --request POST "localhost:3000/api/v1/transfer?destination_account_id=4&source_account_id=5&amount=5.0" \
  --header "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VyX2FnZW50IjoiUG9zdG1hblJ1bnRpbWUvNy42LjAiLCJleHAiOjE1NjM4NTU5NTN9.HVB3HEY6N7WWXUHqOyV117XXr_07V0TFCGLg7d164YM"
```

### /api/v1/balance
```
this route is responsible to get balance of some account_id, account_id is optional because of current_user.
params:
  id: account_id
header:
  ['Authorization'] = JWT

return:
  'O seu saldo atual é: R$:%{value}'

CURL EXAMPLE:
curl --location --request GET "localhost:3000/api/v1/balance?id=4" \
  --header "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VyX2FnZW50IjoiUG9zdG1hblJ1bnRpbWUvNy42LjAiLCJleHAiOjE1NjM4NTU5NTN9.HVB3HEY6N7WWXUHqOyV117XXr_07V0TFCGLg7d164YM"
```

## Architecture
  To save the history of transaction of a user was created table event, this table have a column to save value of balance of account, this way I can guarantee idepodent of all, and dont need to sum all events to get the balance, I can do this easily looking to your last event of account, and if some problemn happen can verify the value run a query to sum all events. When user is created trigger a creation of a new account and the first event of deposit of him account, and I prefer this way to avoid use callback in model, so because of it I create two function one name withdrawal and other deposit and I trigger it in a service, I utilize transaction to avoid some error of one operation happen and other not. Follow the documentation I put the option to utilize to send source_account_id in params, but because of token JWT I can get current_user in any controller.

  One improvement is utilize sidekiq to queue request of transaction.
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
