# lib/channel.rb
class Channel
  attr_reader :name, :id, :purpose, :is_archived, :is_general, :members

  def initialize(name, id, options = {} )
    if name.nil? || name.empty? || id.nil? || id.empty?
      raise ArgumentError
    end
    @name = name
    @id = id
    # Commented out because there's no way I'd be able to remember
    # all this live.
    @purpose = options[:purpose]
    @is_archived = options[:is_archived]
    @is_general = options[:is_archived]
    @members = options[:members]
  end

  # Send a message to this slack channel
  # Returns the data from the Slack server's response
  def sendmsg(msg)
  end

  # Create a class-level instance variable.
  # Musch more likely to work as expected than a class variable
  # See http://www.railstips.org/blog/archives/2006/11/18/class-and-instance-variables-in-ruby/
  @channels = nil

  # Return a memoized hash {id => channel}
  def self.all
    # Return memoized data if available
    return @channels unless @channels.nil?

    # Make the API call and remember the data
    @channels = {}
    SlackApiWrapper.listchannels.each do |channel|
      @channels[channel.id] = channel
    end
    return @channels
  end

  # Foreget all memoized values
  def self.reset
    @channels = nil
  end

  # Return either the first (probably only) channel matching
  # the given name, or nil.
  def self.by_name(name)
    self.all.values.select{ |c| c.name == name }.first
  end

  # Return either the first (probably only) channel matching
  # the given ID, or nil.
  def self.by_id(id)
    # self.all[id]
  end
end
