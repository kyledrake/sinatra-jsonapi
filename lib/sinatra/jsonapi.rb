require 'sinatra'
require 'json'
require './lib/sinatra/jsonapi/version.rb'

module Sinatra
  module JSONAPI
    def self.registered(app)
      app.disable :show_exceptions
      app.disable :raise_errors
      app.disable :protection
      app.enable :raise_errors if test?

      app.before do
        content_type :json
      end

      app.error do
        api_error 'unexpected_error', 'An unexpected error has occured, please try your request again later'
      end

      # Disables Sinatra's internal HTML error message for development mode.
      app.error Sinatra::NotFound do
        not_found
      end

      app.not_found do
        # If 404 body is not the default "Not Found" message, we can return it without processing.
        return response if response.body.first != "<h1>Not Found</h1>"

        api_error 'not_found', "The requested method was not found: #{request.path}"
      end
      
      app.helpers do
        def api_error(type, message)
          payload = {error: {type: type, message: message}}
          halt process_payload(payload)
        end

        def api_response(payload)
          halt process_payload(payload)
        end

        def _jsonapi_to_json(input)
          JSON.unparse input
        end

        def process_payload(payload)
          if params[:callback]
            response_body = "#{params[:callback]}({\n"+
                            "  #{_jsonapi_to_json payload}\n"+
                            "})"
          else
            response_body = _jsonapi_to_json payload
          end
        end
      end
    end
  end

  register JSONAPI
end
