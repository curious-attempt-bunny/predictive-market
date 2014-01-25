# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user    = User.create!(email:'foo@bar.com', password:'12345678')
event   = Event.create!(name: "White Christmas")
snow    = Outcome.create!(event: event, name: 'Snow at Christmas')
no_snow = Outcome.create!(event: event, name: 'No snow at Christmas')
Holding.create!(user: user, outcome: snow, quantity: 10)