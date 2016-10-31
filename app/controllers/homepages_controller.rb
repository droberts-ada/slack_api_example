#require "slack_api_wrapper"
#require "channel"



class HomepagesController < ApplicationController
  def index
    @data = Channel.all
  end

  def create
    result = Channel.by_name(params[:channel]).sendmsg(params[:message])
    if result["ok"]
      flash[:notice] = "Successfully sent message to #{params[:channel]}"
    else
      flash[:notice] = "Failed to send message to #{params[:channel]}: #{result["error"]}"
    end
    redirect_to homepages_index_path
  end

  def new
    @channel_name = params[:channel]
  end
end
