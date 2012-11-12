require 'bundler/setup'
ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require File.join(File.join(File.expand_path(File.dirname(__FILE__))), '..', 'lib', 'sinatra', 'jsonapi.rb')

include Rack::Test::Methods

class TestApp < Sinatra::Base
  register Sinatra::JSONAPI
end

def mock_app(&block)
  @app = Sinatra.new TestApp, &block
end

def app
  @app
end

def as_json(hash)
  hash.to_json
end

describe Sinatra::JSONAPI do
  it 'should return 404 JSON on unknown request' do
    mock_app {
      register Sinatra::JSONAPI
    }
    get '/notfound'
    last_response.body.wont_equal '<h1>Not Found</h1>'
    
    error_resp = {:error => {:type => 'not_found', :message => 'The requested method was not found: /notfound'}}
    
    last_response.body.must_equal as_json(error_resp)
  end
  
  it 'should return generic 500 JSON on uncaught exception' do
    mock_app {
      disable :raise_errors
      get '/error' do
        raise 'Hell!'
      end
    }

    get '/error'

    error_resp = {:error => {:type => 'unexpected_error', :message => 'An unexpected error has occured, please try your request again later'}}

    last_response.body.must_equal as_json(error_resp)
  end
  
  it 'should return custom 500 JSON error' do
    mock_app {
      get '/custom' do
        api_error 'wrong_argument', 'no arguments'
      end
    }

    get '/custom'
    last_response.body.must_equal(as_json(:error => {:type => 'wrong_argument', :message => 'no arguments'}))
  end

  it 'should return hello world json' do

    mock_app {
      get '/hello' do
        api_response(:response => 'hello')
      end
    }

    get '/hello'
    last_response.body.must_equal(as_json(:response => 'hello'))
  end

  it 'should return jsonp when requested' do
    mock_app {
      get '/' do
        api_response(:response => 'hello')
      end
    }

    get '/?callback=abc123'

    expected_resp = {:response => 'hello'}

    expected = "abc123({\n"+
               "  #{as_json expected_resp}\n"+
               "})"

    last_response.body.must_equal expected
  end
  
  it 'should return error with jsonp' do
    mock_app
    get '/sdfsdfsd?callback=abcd123'
    last_response.body.must_match /abcd123\(\{/
    last_response.body.must_match /not found/
  end
end