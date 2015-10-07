require 'test_helper'
require 'rack/test'
require_relative '../lib/reader'

class ReaderTest < Minitest::Test
  def test_reader_gets_words_from_challenge
    r = Reader.new Challenge.new("1")
    assert r.words.is_a?(Hash)
    assert_equal 3, r.words.count
    assert_equal %w|Call me Ishmael|, r.words.keys
  end

  def test_reader_gets_words_from_challenge_id
    r = Reader.new "1"
    assert r.words.is_a?(Hash)
    assert_equal 3, r.words.count
    assert_equal %w|Call me Ishmael|, r.words.keys
  end

  def test_reader_fetches_random_words
    r = Reader.new "1"
    words = r.random_words(2)
    assert_equal 2, words.length
    assert_equal 1, (%w|Call me Ishmael| - words).length
  end

  def test_reader_returns_wordlist_excluding_words
    r = Reader.new "1"
    assert_equal({'me'=>1,'Ishmael'=>1}, r.words_excluding('Call'))
    assert_equal({'me'=>1,'Ishmael'=>1}, r.words_excluding(%w|Call|))
    assert_equal({'Call'=>1,'Ishmael'=>1}, r.words_excluding('me'))
    assert_equal({'Ishmael'=>1}, r.words_excluding('Call','me'))
    assert_equal({'Call'=>1}, r.words_excluding(%w|me Ishmael|))
  end

  def test_reader_returns_challenge_payload
    r = Reader.new "1"
    p = r.challenge_payload
    assert_equal Hash, p.class
    assert_equal "Call me Ishmael.\n", p[:text]
    assert_equal Array, p[:exclude].class
    assert_equal "1", p[:id]
    assert p[:exclude].length > 0
    assert p[:exclude].length < 3
  end

  def test_reader_returns_challenge_payload_with_one_word
    r = Reader.new "0"
    p = r.challenge_payload
    assert_equal Hash, p.class
    assert_equal "foo\n", p[:text]
    assert_equal Array, p[:exclude].class
    assert p[:exclude].length == 0
  end

  def test_reader_verifies_payload
    r = Reader.new "0"
    assert_equal({'foo' => 1}, r.words)
    assert_equal({'foo' => 1}, r.words_excluding([]))
    result = Reader.test_payload({
      id: "0",
      words: {'foo' => 1},
      exclude: []
    })
    assert_equal true, result
  end

  def test_reader_verifies_payload_2
    r = Reader.new "2"
    good = {'quick' => 1,'brown' => 1,'fox' => 1,'jumped' => 1,'lazy' => 1,'dog' => 1}
    exclude = %w|The the over|
    assert_equal(good, r.words_excluding(exclude))
    result = Reader.test_payload({
      id: "2",
      words: good,
      exclude: exclude
    })
    assert_equal true, result
  end

  def test_reader_rejects_id_mismatch
    r = Reader.new "2"
    good = {'quick' => 1,'brown' => 1,'fox' => 1,'jumped' => 1,'lazy' => 1,'dog' => 1}
    exclude = %w|The the over|
    assert_equal(good, r.words_excluding(exclude))
    result = Reader.test_payload({
      id: "3",
      words: good,
      exclude: exclude
    })
    assert_equal false, result
  end
end
