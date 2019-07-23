# README

System to manage a bank account with JWT authentication.
  
To save the history of transaction of a user was created event table, this table has a column to save value of balance of account, this way I can guarantee consistency in system, and do not need to sum all events to get the balance, I do this easily looking at your last event of account, and if some problem happens, verify the value running the query all sum events. When user is created trigger a creation of a new account and the first event of deposit of him account, I use transaction to avoid some error of one operation happen and other not. Follow the documentation I put the option to use to send source_account_id in params, but because of token JWT you can get current_user in any controller.

* Ruby version
  `2.6.2`

* Rails
  `5.2`

* bundler version
  `1.17.2`

* PostgreSQL
  `9.6`
  
## Project setup
  Config database envs in .env file, this is necessary, and after it run:

  `bin/setup`

## How to run the test suite
  `rspec spec`

## How to run quality of code verification
  `rubocop`

## Start server
  `rails s`

## Docker
  1. `docker-compose build`

  2. `docker-compose run web bin/setup`

  3. `docker-compose up`

## Seeds
  The seed created for you this two logins with balance of 100.0:

  `teste1@hotmail.com, password: 321321` | `teste2@hotmail.com, password: 321321`

## API routes
### /api/v1/users/create
```
this route create a new user with account and trigger the first event in your account and you can send the inicial amount of your balance.

params:
{
  name: 'Foo', username: 'Bar', email: 'foo@hotmail.com', password: '321321',
  account: {
    account_number: '321', bank_number: '321'
  },
  event: {
    value: 100.0
  }
}
return:
  Criado com sucesso ou Registro inválido

CURL EXAMPLE:
curl -X POST -k -v -H 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VyX2FnZW50IjoiUG9zdG1hblJ1bnRpbWUvNy42LjAiLCJleHAiOjE1NjM4NTU5NTN9.HVB3HEY6N7WWXUHqOyV117XXr_07V0TFCGLg7d164YM' -H "Content-Type: application/json" http://localhost:3000/api/v1/users/create -d "{\"name\":\"Foo\",\"username\":\"Bar\",\"email\":\"foo@hotmail.com\",\"password\":\"321321\",\"account\":{\"account_number\":\"20321\",\"bank_number\":\"20321\"},\"event\":{\"value\":\"20100.0\"}}"
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
  curl --location --request POST "localhost:3000/api/v1/auth/login?email=teste1@hotmail.com&password=321321" \
  --data ""
```

### /api/v1/users/transfer
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
curl --location --request POST "localhost:3000/api/v1/users/transfer?destination_account_id=2&source_account_id=1&amount=5.0" \
  --header "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VyX2FnZW50IjoiUG9zdG1hblJ1bnRpbWUvNy42LjAiLCJleHAiOjE1NjM4NTU5NTN9.HVB3HEY6N7WWXUHqOyV117XXr_07V0TFCGLg7d164YM"
```

### /api/v1/accounts/balance
```
this route is responsible to get balance of some account, id is optional because of current_user.
params:
  id: account_id
header:
  ['Authorization'] = JWT

return:
  'O seu saldo atual é: R$:%{value}'

CURL EXAMPLE:
curl --location --request GET "localhost:3000/api/v1/accouts/balance?id=1" \
  --header "Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VyX2FnZW50IjoiUG9zdG1hblJ1bnRpbWUvNy42LjAiLCJleHAiOjE1NjM4NTU5NTN9.HVB3HEY6N7WWXUHqOyV117XXr_07V0TFCGLg7d164YM"
```

## Improvements
  - If I have a valid session, I can realize transactions and see balance of any account, 
  the correctly way is get current_user only in my opinion or insert a validation to source_account_id
  only can be logged user.

  - response and errors in API can be better.

  - Utilize sidekiq to queue request of transactions.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
