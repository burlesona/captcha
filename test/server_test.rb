require 'rack/test'
require_relative 'test_helper'
require_relative '../lib/server'

class ServerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Server.new
  end

  def test_app_responds_to_get_root
    get '/'
    assert_equal 200, last_response.status
  end

  def test_app_returns_a_json_response
    get '/'
    assert_equal 'application/json', last_response.content_type
  end

  def test_app_returns_a_text
    get '/'
    body = JSON.parse(last_response.body, symbolize_names: true)
    assert body[:text]
    assert body[:text].length > 0
  end

  def test_app_returns_an_id
    get '/'
    body = JSON.parse(last_response.body, symbolize_names: true)
    assert body[:id]
    assert_equal true, %w|0 1 2 3 4 5|.include?(body[:id])
  end

  def test_app_returns_excludes
    get '/'
    body = JSON.parse(last_response.body, symbolize_names: true)
    assert body[:exclude]
    assert_equal Array, body[:exclude].class
  end

  def test_app_validates_payload_0
    good = {'foo'=>1}
    exclude = []
    data = {id: '0', words:good, exclude:exclude}
    post '/', JSON.generate(data)
    assert_equal 200, last_response.status
  end

  def test_app_validates_payload_2
    good = {'quick' => 1,'brown' => 1,'fox' => 1,'jumped' => 1,'lazy' => 1,'dog' => 1}
    exclude = %w|The the over|
    data = {id: '2', words:good, exclude:exclude}
    post '/', JSON.generate(data)
    assert_equal 200, last_response.status
  end
end
