# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user    = User.find_by email:'foo@bar.com'
user    = User.create! email:'foo@bar.com', password:'12345678' unless user
user.update_attributes(admin: true)
event   = Event.find_or_create_by! name: "White Christmas"
snow    = event.outcomes.find_or_create_by! event: event, name: 'Snow at Christmas'
no_snow = event.outcomes.find_or_create_by! event: event, name: 'No snow at Christmas'
user.purchase(snow, 10) if user.quantity(snow) == 0

event   = Event.find_or_create_by! name: "Sunrise tomorrow"
shine   = event.outcomes.find_or_create_by! name: "The sun comes up and shines brightly."
cloudy  = event.outcomes.find_or_create_by! name: "The sun comes up but is obscured by clouds."
doom    = event.outcomes.find_or_create_by! name: "The sun does not come up."
