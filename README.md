# Sinatra::JSONAPI [![](https://secure.travis-ci.org/kyledrake/sinatra-jsonapi.png)](http://travis-ci.org/kyledrake/sinatra-jsonapi)

This is an extension for Sinatra that makes the Base class return JSON for 404 and 500 errors, and gives you api\_response and api\_error for quick JSON responses.

## Caveats

Does not automatically try to convert response. You need to use api\_response or api\_error, or halt with proper JSON like such:

    get '/ping' do
      halt {response: 'pong'}.to_json
    end

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-jsonapi', require: 'sinatra/jsonapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-jsonapi

## Usage

For classy apps:

    require 'sinatra'
    require 'sinatra/jsonapi'

    class MyCoolAPI < Sinatra::Base
      register Sinatra::JSONAPI

      get '/hello' do
        api_response response: 'world!'
      end

      # Returns:
      # {"response":"world!"}

      get '/break' do
        api_error :your_error_type, 'human readable version of error message'
      end

      # Returns:
      # {"error":{"error_type":"your_error_type", "message":"human readable version of your error message"}}
    end

For classic style apps (no class), registration of the extension happens automatically:

    require 'sinatra'
    require 'sinatra/jsonapi'

    get '/hello' do
      api_response response: 'world!'
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
