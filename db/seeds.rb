p 'started'
user = FactoryBot.create(:user, email: 'teste1@hotmail.com', password: '321321')
account = FactoryBot.create(:account, user_id: user.id)
FactoryBot.create(:event, account_id: account.id)
p 'created user with email: teste1@hotmail.com, password: 321321 and balance of 100.0'
user = FactoryBot.create(:user, email: 'teste2@hotmail.com', password: '321321')
account = FactoryBot.create(:account, user_id: user.id)
FactoryBot.create(:event, account_id: account.id)
p 'created user with email: teste2@hotmail.com, password: 321321 and balance of 100.0'
p 'finished'