require 'test_helper'

class ChannelTest < ActiveSupport::TestCase
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


  #
  # SELF METHODS
  #

  test "Channel.all should return an array of channels" do
    VCR.use_cassette("channels") do
      channels = Channel.all
      assert_kind_of Array, channels
      assert_not channels.empty?
      channels.each do |channel|
        assert_kind_of Channel, channel
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

  # TODO: uncomment me if Slack ever starts giving back
  # duplicate channels
  # test "Channel.by_name should return the first match" do
  #   name = "test name"
  #   channel = Channel.by_name(name)
  #   assert_kind_of Channel, channel
  #   assert_equal channel.name, name
  # end
end
