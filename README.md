# Ruby homework

## Task
Write a migration and ActiveRecord model that tracks restaurant reservations.
Assume there is a table in your relational database named "reservations".
Reservations have start time, an end time and a table number.

Write some ActiveRecord validations that check new reservations for overbooking of the same table in the restaurant.
For example, table #10 cannot have 2 reservations for the same period of time.
This validation(s) should check time overlap for both
record creation and updates.

Unit tests are a must to make sure your double booking validations are working.
(rspec and unittests)


## Setup
To install and run tests, type
```bash
rake db:create:all
rake db:migrate
rake db:test:prepare
rspec
```
## Demo
http://floating-sands-5227.herokuapp.com/
