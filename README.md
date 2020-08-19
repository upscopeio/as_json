# AsJson
[![Build Status](https://travis-ci.org/upscopeio/as_json.svg?branch=master)](https://travis-ci.org/upscopeio/as_json)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/as_json`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'as_json'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install as_json

## Usage
Including the `AsJson` module in your models you will have access to the `json_with` method, allowing you to define which attributes/methods should be converted to JSON 

``` ruby
# app/models/team.rb
class Team < ApplicationRecord
  include AsJson
  
  json_with :name
end


# app/models/user.rb
class User < ApplicationRecord
  include AsJson
  
  belongs_to :team
  
  json_with :name, team: [:name]
end

team = Team.create name: 'Acme'
user = User.create name: 'John Doe', team: team
user.as_json
# => {'name' => 'John Doe', 'team' => { 'name' => 'Acme', '_type' => 'team'}, '_type' => 'user' }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/upscopeio/as_json.
