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

event   = Event.create! name: "Sunrise tomorrow"
shine   = event.outcomes.create name: "The sun comes up and shines brightly."
cloudy  = event.outcomes.create name: "The sun comes up but is obscured by clouds."
doom    = event.outcomes.create name: "The sun does not come up."
