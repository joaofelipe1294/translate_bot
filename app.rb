require 'json'
require 'sinatra'

# Dir["./app/models/*.rb"].each {|file| require file }
Dir["./app/services/**/*.rb"].each {|file| require file }

class App < Sinatra::Base

  get '/' do
    'Hello world!'
  end

  post '/webhook' do
    request.body.rewind
    result = JSON.parse(request.body.read)["queryResult"]

    # if result["contexts"].present?
    #   response = InterpretService.call(result["action"], result["contexts"][0]["parameters"])
    # else
    #   response = InterpretService.call(result["action"], result["parameters"])
    # end

    response = ProxyService.new(result).call



    content_type :json, charset: 'utf-8'
    {
      "fulfillmentText": response,
      "payload": {
        "telegram": {
          "text": response
        }
      }
    }.to_json
  end

end
