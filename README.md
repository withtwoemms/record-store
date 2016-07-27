Code challenge
---

created with ruby 2.2.1; bundler 1.12.4

* in the root of the project, `bundle install` to get dependencies
* type `rspec` to run all tests
* open a separate terminal window and type `rackup` to initiate server
  - this will allow you to access the Catalog API at localhost:8765
* to use the app, open `app/views/interface.html` in a browser
* only the following endpoints are currently available
  - 'GET /records/gender'
  - 'GET /records/birthdate'
  - 'GET /records/name'

---

Future work:
* form validation
* serve interface via rackup
* institute `remove` functionality
* consider making a parser class if functionality needed elsewhere
