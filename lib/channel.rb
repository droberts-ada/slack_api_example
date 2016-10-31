# lib/channel.rb
class Channel
  attr_reader :name, :id, :purpose, :is_archived, :members

  def initialize(name, id, options = {} )
    raise ArgumentError if name == nil || name == "" || id == nil || id == ""

    @name = name
    @id = id

    @purpose = options[:purpose]
    @is_archived = options[:is_archived]
    @is_general = options[:is_archived]
    @members = options[:members]
  end

  def sendmsg(msg)
    SlackApiWrapper.sendmsg(@name, msg)
  end

  # Create a class-level instance variable.
  # Musch more likely to work as expected than a class variable
  # See http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
  class << self
    attr_reader :channels
  end

  def self.all
    @channels ||= SlackApiWrapper.listchannels
  end

  def self.reset
    @channels = nil
  end

  # Return either the first (probably only) channel matching
  # the given name, or nil.
  def self.by_name(name)
    all.select{ |c| c.name == name }.first
  end

  # Return either the first (probably only) channel matching
  # the given ID, or nil.
  def self.by_id(id)
    all.select{ |c| c.id == id }.first
  end
end
