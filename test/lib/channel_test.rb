require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
  def setup
    Channel.reset
  end

  test "whether the tests are running" do
    assert true
  end

  #
  # INSTANCE METHODS
  #

  test "Channel can be created with name and ID" do
    name = "test name"
    id = "test id"
    c = Channel.new(name, id)
    assert_equal c.name, name
    assert_equal c.id, id
  end

  test "Channel cannot be created without a name" do
    assert_raises ArgumentError, "nil name" do
      Channel.new(nil, "test id")
    end

    assert_raises ArgumentError, "empty name" do
      Channel.new("", "test id")
    end
  end

  test "Channel cannot be created without an id" do
    assert_raises ArgumentError, "nil ID" do
      Channel.new("test name", nil)
    end

    assert_raises ArgumentError, "empty ID" do
      Channel.new("test name", "")
    end
  end

  test "Optional params are stored" do
    name = "test name"
    id = "test id"
    options = {
      purpose: "test purpose",
      is_archived: false,
      is_general: false,
      members: []
    }
    c = Channel.new(name, id, options)
    assert_equal c.name, name
    assert_equal c.id, id
    assert_equal c.purpose, options[:purpose]
    assert_equal c.is_archived, options[:is_archived]
    assert_equal c.is_general, options[:is_general]
    assert_equal c.members, options[:members]
  end

  #
  # SELF METHODS
  #

  test "Channel.all should return an array of channels" do
    VCR.use_cassette("channels") do
      channels = Channel.all
      assert_kind_of Hash, channels
      assert_not channels.empty?
      channels.each do |id, channel|
        assert_kind_of Channel, channel
        assert_equal id, channel.id
      end
    end
  end

  test "Channel.by_name should return nil if no match" do
    VCR.use_cassette("channels") do
      channel = Channel.by_name("this-channel-does-not-exist")
      assert_nil channel
    end
  end

  test "Channel.by_name should return the only match" do
    VCR.use_cassette("channels") do
      name = "test-api-brackets"
      channel = Channel.by_name(name)
      assert_kind_of Channel, channel
      assert_equal channel.name, name
    end
  end

  test "Channel.by_name should return the first match" do
    # To get the duplicate_channel cassette, I copied
    # an existing cassette and hand-edited the JSON to
    # look like what I wanted, in this case having two
    # channels with the same name.
    VCR.use_cassette("duplicate_channel") do
      name = "duplicate-channel-name"
      channel = Channel.by_name(name)
      assert_kind_of Channel, channel
      assert_equal channel.name, name
    end
  end

  test "Channel.by_id should return nil if no match" do
    VCR.use_cassette("channels") do
      channel = Channel.by_id("this-id-does-not-exist")
      assert_nil channel
    end
  end

  test "Channel.by_id should return the only match" do
    VCR.use_cassette("channels") do
      id = "C14UN1PV2"
      channel = Channel.by_id(id)
      assert_kind_of Channel, channel
      assert_equal channel.id, id
    end
  end

  #
  # MEMOIZATION
  #

  test "Channel.all doesn't pick up changes without reset" do
    # Load from one set of test data
    VCR.use_cassette("alpha-test-channel") do
      channels = Channel.all

      # Confirm the test data is as expected
      assert_equal 1, channels.length
      assert_kind_of Channel, channels.values.first
      assert_equal "alpha-test-channel", channels.values.first.name
    end

    # Change the "server" (cassette) to use a different
    # set of test data
    VCR.use_cassette("bravo-test-channel") do
      channels = Channel.all

      # Confirm the loaded data hasn't changed, and still matches
      # the first cassette
      assert_equal 1, channels.length
      assert_kind_of Channel, channels.values.first
      assert_equal "alpha-test-channel", channels.values.first.name
    end
  end

  test "Channel.all does pick up changes after reset" do
    # Load from one set of test data
    VCR.use_cassette("alpha-test-channel") do
      channels = Channel.all
      # Confirm the test data is as expected
      assert_equal 1, channels.length
      assert_kind_of Channel, channels.values.first
      assert_equal "alpha-test-channel", channels.values.first.name
    end

    # Change the "server" (cassette) to use a different
    # set of test data
    VCR.use_cassette("bravo-test-channel") do
      # Call reset to force reload
      Channel.reset
      channels = Channel.all

      # Confirm the loaded data matches the new cassette
      assert_equal 1, channels.length
      assert_kind_of Channel, channels.values.first
      assert_equal "bravo-test-channel", channels.values.first.name
    end
  end
end
