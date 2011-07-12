require 'eventmachine'
require 'thin/async'

module Thin
  module Async
    class Test
      VERSION = '1.0.0'

      class Callback
        attr_reader :status, :headers, :body

        def call args
          @status, @headers, deferred_body = args
          @body = ""
          deferred_body.each {|s| @body << s }

          deferred_body.callback { EM.stop }
        end
      end
    
      def initialize(app, options={})
        @app = app
      end

      def call(env)
        callback = Callback.new
        env.merge! 'async.callback' => callback

        EM.run do
          result = @app.call(env)
          
          unless result == Thin::AsyncResponse::Marker
            EM.next_tick do
              EM.stop
              return result
            end
          end
        end

        [callback.status, callback.headers, callback.body]
      end
    end
  end
end
