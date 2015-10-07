class Challenge
  NotFoundError = Class.new(StandardError)

  attr_reader :id, :text

  def initialize(id)
    @id = id
    @text = file.readlines.join("\n")
  end

  def file
    @file ||= File.open("./texts/#{id}")
  rescue Errno::ENOENT
    raise NotFoundError, "No such challenge: #{id}"
  end

  class << self
    def all_ids
      Dir["./texts/*"].map{|s| s.split("/").last }
    end

    def random
      new all_ids.sample
    end
  end
end
