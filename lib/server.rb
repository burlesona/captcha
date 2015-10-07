require 'sinatra'
require 'json'
require_relative 'reader'

class Server < Sinatra::Base
  def json(hash={})
    content_type :json
    JSON.generate(hash)
  end

  def request_data
    # Basic shallow symbolize keys instead of the deep symbolize_names
    request.body.rewind
    JSON.parse(request.body.read).each_with_object(Hash.new) do |(k,v),h|
      h[k.to_sym] = v
    end
  end

  # Get a random challenge
  get '/' do
    r = Reader.new(Challenge.random)
    json r.challenge_payload
  end

  # Check a challenge
  post '/' do
    begin
      Reader.test_payload(request_data) ? 200 : 400
    rescue Challenge::NotFoundError
      400
    end
  end
end
