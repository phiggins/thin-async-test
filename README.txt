= thin-async-test

* https://github.com/phiggins/thin-async-test

== DESCRIPTION:

Rack middleware to convince thin-async and rack-test to play nicely.

== FEATURES/PROBLEMS:

* Allows async thin apps to be tested like regular synchronous ones.
* Doesn't interfere with regular synchronous apps.
* Stops and starts the eventmachine reactor for each test, so test speed suffers.

== SYNOPSIS:

  require 'thin/async'
  
  # Step 1: Make your rack app that uses thin and thin-async's AsyncResponse.
  class MyRackApp
    def call(env)
      response = Thin::AsyncResponse.new(env)
  
      response.headers["X-Foo"] = "bar"
  
      response << "Here's some body..."
  
      EM.add_timer(0.1) do
        response << "long running action"
  
        response.done
      end
      
      response.finish
    end  
  end
  
  # Step 2: Create your test class with rack-test.
  class TestMyRackApp < MiniTest::Unit::TestCase
    include Rack::Test::Methods
  
    # Step 3: Define your app method, but wrap it with a Thin::Async::Test
    def app
      Thin::Async::Test.new(MyRackApp)
    end
  
    # Step 4: You can test your async rack actions like syncronous ones.
    def test_my_rack_app
      get("/")
  
      assert_equal 200, last_response.status 
    end
  end

== REQUIREMENTS:

* Designed to work with thin and thin-async, but could potentially work with other stuff.
* Tested with eventmachine-1.0.0.beta.3 and ruby-1.9.2-p180.

== INSTALL:

Nothing special.

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2011 Pete Higgins

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
