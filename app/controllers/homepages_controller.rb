#require "slack_api_wrapper"
#require "channel"



class HomepagesController < ApplicationController
  def index
    @data = Channel.all
  end

  def create
    SlackApiWrapper.sendmsg(params[:channel], params[:message])
  end

  def new
    @channel_name = params[:channel]
  end
end
