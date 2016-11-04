class HomepagesController < ApplicationController
  def index
    @channels = Channel.all.values.sort_by{ |c| c.name }
  end

  def create
    channel = Channel.by_id(params[:channel])
    result = channel.sendmsg(params[:message])
    if result["ok"]
      flash[:notice] = "Successfully sent message to #{channel.name}"
    else
      flash[:notice] = "Failed to send message to #{channel.name}: #{result["error"]}"
    end
    redirect_to homepages_index_path
  end

  def new
    @channel = Channel.by_id(params[:channel])
  end
end
