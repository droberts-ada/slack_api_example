require 'httparty'

class SlackApiWrapper
  BASE_URL = "https://slack.com/api/"
  TOKEN = ENV["SLACK_TOKEN"]

  def self.listchannels()
    url = BASE_URL + "channels.list?" + "token=#{TOKEN}" + "&pretty=1&exclude_archived=1"
    data = HTTParty.get(url)
    channel_list = []
    if data["channels"]
      data["channels"].each do |channel|
        wrapper = Channel.new channel["name"], channel["id"] , purpose: channel["purpose"], is_archived: channel["is_archived"], members: channel["members"]
        channel_list << wrapper
      end
    end
    return channel_list
  end

  def self.sendmsg(channel, msg, token = nil)
    puts "Sending message to channel #{channel}: #{msg}"

    url = BASE_URL + "chat.postMessage?" + "token=#{TOKEN}"
    data = HTTParty.post(url,
    body:  {
      "text" => "#{msg}",
      "channel" => "#{channel}",
      "username" => "Roberts-Robit",
      "icon_emoji" => ":robot_face:",
      "as_user" => "false"
    },
    :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end
end
