# lib/channel.rb
class Channel
  attr_reader :name, :id, :purpose, :is_archived, :members

  def initialize(name, id, options = {} )
    # Commented out because there's no way I'd be able to remember
    # all this live.
    # @purpose = options[:purpose]
    # @is_archived = options[:is_archived]
    # @is_general = options[:is_archived]
    # @members = options[:members]
  end

  # Send a message to this slack channel
  # Returns the data from the Slack server's response
  def sendmsg(msg)
  end

  # Create a class-level instance variable.
  # Musch more likely to work as expected than a class variable
  # See http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
  class << self
    attr_reader :channels
  end

  # Return a memoized set of all channels
  def self.all
  end

  # Foreget all memoized values
  def self.reset
  end

  # Return either the first (probably only) channel matching
  # the given name, or nil.
  def self.by_name(name)
  end

  # Return either the first (probably only) channel matching
  # the given ID, or nil.
  def self.by_id(id)
  end
end
