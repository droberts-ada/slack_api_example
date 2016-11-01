require 'test_helper'

class SlackApiWrapperTest < ActiveSupport::TestCase
  test "whether the tests are running" do
    assert true
  end

  test "listchannels returns an array of Channels" do
    VCR.use_cassette("channels") do
      channels = SlackApiWrapper.listchannels
      assert_kind_of Array, channels
      assert_not channels.empty?
      channels.each do |channel|
        assert_kind_of Channel, channel
      end
    end
  end

  test "Can send valid message to real channel" do
    VCR.use_cassette("channels") do
      message = "test message"
      response = SlackApiWrapper.sendmsg("test-api-brackets", message)
      assert response["ok"]
      assert_equal response["message"]["text"], message
    end
  end

  test "Can't send message to fake channel" do
   VCR.use_cassette("channels") do
     response = SlackApiWrapper.sendmsg("this-channel-does-not-exist", "test message")
     assert_not response["ok"]
     assert_not_nil response["error"]
   end
 end
end
