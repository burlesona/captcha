require_relative 'challenge'

class Reader
  attr_reader :challenge, :words
  def initialize(challenge_or_id)
    @challenge = get_challenge(challenge_or_id)
    parse!
  end

  def random_words(n)
    if n && words.length > n
      words.keys.sample(n)
    else
      []
    end
  end

  def words_excluding(*list)
    exclusions = words.keys & Array(list).flatten
    words.select{|k,v| !exclusions.include?(k) }
  end

  def challenge_payload
    { id: challenge.id,
      text: challenge.text,
      exclude: random_words(rand(1...words.length))
    }
  end

  def self.test_payload(payload)
    r = new(payload[:id])
    r.words_excluding(payload[:exclude]) == payload[:words]
  end

  private
  def get_challenge(input)
    input.is_a?(Challenge) ? input : Challenge.new(input)
  end

  def parse!
    return if @words
    @words = challenge.text.split(/\W+/).each_with_object(Hash.new) do |word,set|
      set[word] ||= 0
      set[word] += 1
    end
  end
end
