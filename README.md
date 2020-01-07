# A Ruby wrapper for the [branch.io](http://branch.io) [public API](https://github.com/BranchMetrics/branch-deep-linking-public-api)

[![Gem](https://img.shields.io/gem/v/branch_io.svg?style=flat)](https://rubygems.org/gems/branch_io)
[![Downloads](https://img.shields.io/gem/dt/branch_io.svg?style=flat)](https://rubygems.org/gems/branch_io)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/ushu/branch_io/blob/master/LICENSE)
<!-- [![CircleCI](https://img.shields.io/circleci/project/github/ushu/branch_io.svg)](https://circleci.com/gh/ushu/branch_io) -->

Please see the [Branch documentation](https://docs.branch.io) for general information. Please report any
problems by opening issues in this repo.

This is a simple [HTTparty](https://github.com/jnunemaker/httparty)-based gem for accessing the branch.io REST APIs,
as described [here](https://github.com/BranchMetrics/branch-deep-linking-public-api). See the [Branch API documentation](https://docs.branch.io/pages/apps/api/) for further details.

It follows the exact design of the original REST API: basically links are resources you can generate and update,
provided you hold the required credentials.

**BEWARE: this gem does not (yet) cover all the API calls of the API, for now on only the link creation/update is supported**


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'branch_io'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install branch_io


## Basic Usage

To access the APIs, you need to create a `BranchIO::Client` instance, passing in your
**branch.io key** and your **branch.io secret** respectively.

```ruby
# Create a new client
> client = BranchIO::Client.new("key_test_xxx", "secret_test_yyyy")
=> #<BranchIO::Client:0x007f8e7192a2a0 @branch_key="key_test_xxx", @branch_secret="secret_test_yyy">

# Ask the server for a new link
> res = client.link(feature: "test")
=> #<BranchIO::Client::UrlResponse:0x007f8e718c6a20 @response="...">

# Check for success and print the URL
> if res.success?
    puts res.url
  end
https://uym7.test-app.link/ABCDEFG...
```

Please not that the `gem` reads the `BRANCH_KEY` and `BRANCH_SECRET` environment
variables by default, and provided these are defined passing them to the client is
optional:

```ruby
# Provided BRANCH_KEY and BRANCH_SECRET are defined
> client = BranchIO::Client.new
=> #<BranchIO::Client:... @branch_key="key_test_xxx", @branch_secret="secret_test_yyy">
```

Similarly all the methods of the "default" client (the one without arguments) are made
available on the module itself:

```ruby
# Provided BRANCH_KEY and BRANCH_SECRET are defined
> res = BranchIO.link(feature: "test") # <= same as BranchIO.new.link(...)
=> #<BranchIO::Client::UrlResponse:0x007f8e718c6a20 @response="...">
```


## Available API calls

### `Client#link` and `Client#link!`: Registers a [new deep linking URL](https://github.com/BranchMetrics/branch-deep-linking-public-api#creating-a-deep-linking-url)

This method registers a new deep linking URL to the `branch.io` service. The arguments
are passed to a new instance of `BranchIO::LinkProperties`.

```ruby
# Call the service
res = client.link(
  feature: "test",
  channel: "test",
  campaign: "test",
  stage: 1,
  alias: "testsingle",
  type: "test",
  tags: [ "test" ],
  data: {
    test: true
  }
)

# Inspect the server response
if res.success?
  puts "Successfully created URL: #{res.url}"
else
  puts "Error creating URL: #{res.error}"
end
```

_The only difference between `#link` and `#link!` is that the latter version will
raise a new `BranchIO::ErrorApiCallFailed` exception in case of an error._

### `Client#links` and `Client#links!`: Registers a bulk of [deep linking URLs](https://github.com/BranchMetrics/branch-deep-linking-public-api#creating-a-deep-linking-url)

This method registers a bulk deep linking URLs to the `branch.io` service. The arguments
are passed to a new instances of `BranchIO::LinkProperties`.

```ruby
# Call the service
url_configs = [
  { feature: "test" }, # First link
  { feature: "test", stage: 2 } # second link
  # etc..
]
res = client.links(url_configs)

# Inspect the server response
if res.success?
  puts "Successfully created #{res.urls.count} URLs: #{res.urls.join(',')}"
else
  puts "Error creating URLs: #{res.errors.join(',')}"

  # There has been errors, but some URLs might be valid
  if res.urls.count > 0
      puts "Successfully created #{res.urls.count} URLs out of #{url_configs.count}: #{res.urls.join(',')}"
  end
end
```

_The only difference between `#links` and `#links!` is that the latter version will
raise a new `BranchIO::ErrorApiCallFailed` exception in case of an error._

### `Client#link_info` and `Client#link_info!`: Returns information about a [deep linking URL](https://github.com/BranchMetrics/branch-deep-linking-public-api#creating-a-deep-linking-url)

**BEWARE: this method requires the BRANCH_SECRET to be defined**

This method queries an existing link URL for its properties.

```ruby
# Call the service
res = client.link_info("https://...")

# Inspect the server response
if res.success?
  puts "Successfully retrieved link info: #{res.link_properties.to_json}"
else
  puts "Error retrieving link info: #{res.error}"
end
```

**The only difference between `#link_info` and `#link_info!` is that the latter version will
raise a new `BranchIO::ErrorApiCallFailed` exception in case of an error.**

### `Client#update_link` and `Client#update_link!`: Updates a [deep linking URL](https://github.com/BranchMetrics/branch-deep-linking-public-api#creating-a-deep-linking-url)

**BEWARE: this method requires the BRANCH_SECRET to be defined**

This method updates the properties of an existing link and returns the new updated
set of properties.

```ruby
# Call the service
res = client.update_link("https://...", stage: 3)

# Inspect the server response
if res.success?
  puts "Successfully updated link info: #{res.link_properties.to_json}"
else
  puts "Error updating link info: #{res.error}"
end
```

**The only difference between `#update_link` and `#update_link!` is that the latter version will
raise a new `BranchIO::ErrorApiCallFailed` exception in case of an error.**

### `Client#delete_link` and `Client#delete_link!`: Deletes a [deep linking URL](https://github.com/BranchMetrics/branch-deep-linking-public-api#creating-a-deep-linking-url)

**BEWARE: this method requires the BRANCH_SECRET to be defined**

This method deletes an existing link and returns the URL and deletion confirmation.

```ruby
# Call the service
res = client.delete_link("https://...")

# Inspect the server response
if res.success?
  puts "Successfully deleted link: #{res.link_deleted.to_json['url']}"
else
  puts "Error updating link info: #{res.error}"
end
```

**The only difference between `#delete_link` and `#delete_link!` is that the latter version will
raise a new `BranchIO::ErrorApiCallFailed` exception in case of an error.**

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ushu/branch_io. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## TODO

 - [ ] Add support for the `/app` API calls
 - [ ] Add some docs to the code
 - [ ] Write a better README...

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
