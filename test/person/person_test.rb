# frozen_string_literal: true

require './test/test_helper'

class FellowshipOnePersonTest < Minitest::Test
  def test_exists
    assert FellowshipOne::Person
  end
end
