# Author::    radiospiel  (mailto:eno@radiospiel.org)
# Copyright:: Copyright (c) 2011, 2012 radiospiel
# License::   Distributes under the terms  of the Modified BSD License, see LICENSE.BSD for details.
require_relative 'test_helper'

class SimpleUITest < Test::Unit::TestCase
  def test_loaded
    "string".warn "hello world!"
  end
end
