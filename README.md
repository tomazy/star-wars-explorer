# Star Wars Explorer

* System dependencies (for development)
  - Ruby 2.5.1
  - Node 10.6.0
  - Yarn 1.7.0
  - PostgreSQL 9.4.14 (should work with newer)
  - Google Chrome 67.0.3396.99 (for system testing)

* Development setup

```bash
ruby --version
# ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]

gem install bundler
# Successfully installed bundler-1.16.3
# 1 gem installed

git clone https://github.com/tomazy/star-wars-explorer.git
cd star-wars-explorer
bundle install
# ... long list of gems

```

* Database creation
  - `bin/rails db:create`
  - `bin/rails db:migrate`

* Starting the server
  - `bin/rails server`

* How to run the test suite
  - `bin/rails test:system`
  - `bin/rails test`

* Deployment instructions
  - `git push heroku master`
  - `heroku run rake db:migrate`
