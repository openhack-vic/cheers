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
  before_filter :authenticate_user!
  include ActionController::Live

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @music = @user.music
  end

  def listen
    @user = User.find(1)
    @theme_song = @user.music.where(:is_current_theme => true).first
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ServerSide::SSE.new(response.stream)

    begin
      loop do
        sse.write({ :user => "#{@user.name}", :song => "#{@theme_song.song}" }, :event => "enter")
        sleep 1
      end

    rescue IOError
    ensure
      sse.close
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :description, :email, :password, :password_confirmation, :current_password)
  end

end
