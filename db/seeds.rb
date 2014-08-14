# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

table = Table.create(number: 1)
Reservation.create(start_time: Time.now, end_time: 1.hour.since, table: table)
table = Table.create(number: 2)
Reservation.create(start_time: Time.now, end_time: 1.hour.since, table: table)
