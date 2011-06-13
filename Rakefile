# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :minitest
Hoe.plugin :git

Hoe.spec 'thin-async-test' do
  developer('pete higgins', 'pete@peterhiggins.org')

  extra_dev_deps << ["thin_async",  "~> 0.1.0"]
  extra_dev_deps << ["rack-test",   "~> 0.6.0"]

  self.testlib = :minitest
end

# vim: syntax=ruby
