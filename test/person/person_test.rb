# frozen_string_literal: true

require './test/test_helper'

class FellowshiponePersonTest < Minitest::Test
  def test_exists
    assert Fellowshipone::Client::Person
  end
end
