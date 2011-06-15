require "rack/test"
require "thin/async/test"

STATUS  = 200
HEADERS = {"X-Foo" => "bar"}
BODY    = "o hai!" 

TestApp = lambda do |env|
  case env['PATH_INFO']
  when '/sync'
    [STATUS, HEADERS, BODY]
  when '/async'
    response = Thin::AsyncResponse.new(env, STATUS, HEADERS)

    response << BODY

    EM.next_tick do
      response << BODY

      response.done
    end
    
    response.finish
  end
end

describe Thin::Async::Test do
  include Rack::Test::Methods

  def app
    Thin::Async::Test.new(TestApp)
  end

  it "returns normal response for syncronous action" do
    get "/sync"

    assert_equal STATUS,  last_response.status
    assert_equal "bar",   last_response.headers["X-Foo"]
    assert_equal BODY,    last_response.body
  end

  it "returns async response for asyncronous action" do
    get "/async"

    assert_equal STATUS,  last_response.status
    assert_equal "bar",   last_response.headers["X-Foo"]
    assert_equal BODY*2,  last_response.body
  end

  it "doesn't hog the reactor's time" do
    foo = nil
    EM.next_tick { foo = "bar" }

    get "/sync"
    
    assert_equal "bar", foo
  end
end
