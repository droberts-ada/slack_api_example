class ChannelsController < ApplicationController
  def index
    @channels = Channel.all.values.sort_by{ |c| c.name }
  end

  def show
    @channel = Channel.by_id(params[:id])
  end

  def sendmsg
    channel = Channel.by_id(params[:id])
    result = channel.sendmsg(params[:message])
    if result["ok"]
      flash[:notice] = "Successfully sent message to #{channel.name}"
    else
      flash[:notice] = "Failed to send message to #{channel.name}: #{result["error"]}"
    end
    redirect_to channels_path
  end
end
