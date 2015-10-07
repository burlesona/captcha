require 'test_helper'
require 'rack/test'
require_relative '../lib/challenge'

class ChallengeTest < Minitest::Test
  def test_challenge_reads_file
    r = Challenge.new "0"
    assert_equal "0", r.id
    assert_equal "foo\n", r.text
  end

  def test_challenge_reads_another_file
    r = Challenge.new "1"
    assert_equal "1", r.id
    assert_equal "Call me Ishmael.\n", r.text
  end

  def test_challenge_finds_no_file
    assert_raises(Challenge::NotFoundError){
      Challenge.new('alpha')
    }
  end

  def test_challenge_knows_all_ids
    assert_equal %w|0 1 2 3 4 5|, Challenge.all_ids
  end

  def test_returns_random_challenge
    assert_equal Challenge, Challenge.random.class
  end
end
