# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :minitest
Hoe.plugin :git

Hoe.spec 'thin-async-test' do
  developer('pete higgins', 'pete@peterhiggins.org')

  extra_dev_deps << ["eventmachine",  "~> 1.0.0.beta.3"]
  extra_dev_deps << ["rack",          "~> 1.3.0"]
  extra_dev_deps << ["thin_async",    "~> 0.1.1"]
  extra_dev_deps << ["thin",          "~> 1.2.11"]
  extra_dev_deps << ["rack-test",     "~> 0.6.0"]

  self.testlib = :minitest
end

# vim: syntax=ruby
