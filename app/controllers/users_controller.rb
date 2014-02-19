require 'json'

module ServerSide
  class SSE
    def initialize io
      @io = io
    end
    
    def write object, options = {}
      options.each do |k, v|
        @io.write "#{k}: #{v}\n"
      end
      @io.write "data: #{object}\n\n"
    end
    
    def close
      @io.close
    end
  end
end

class UsersController < ApplicationController
  include ActionController::Live
  before_filter :authenticate_user!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @music = @user.music
  end

  def entrance
    @user = User.find(params[:id])
    @theme_song = Music.where(:is_current_theme => true, :user_id => params[:id]).first
    if @theme_song
      # Do something here!
      
      response.headers['Content-Type'] = 'text/event-stream'
      sse = ServerSide::SSE.new(response.stream)
      
      begin
        sse.write({ :user => "#{@user.name}", :song => "#{@theme_song.song}" })
      rescue IOError
      ensure
        sse.close
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :description, :email, :password, :password_confirmation, :current_password)
  end

end
