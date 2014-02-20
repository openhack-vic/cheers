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
      @io.write "data: #{JSON.dump(object)}\n\n"
    end

    def close
      @io.close
    end
  end
end

class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:listen]
  include ActionController::Live

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @music = @user.music
  end

  def listen
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ServerSide::SSE.new(response.stream)

    begin
      # Set load to true when info is passed down
      # USER.NAME = #{@user.name}
      # MUSIC.SONG = #{@music.song}
      sse.write({ :user => "USER.NAME", :song => "MUSIC.SONG", :load => false }, :event => "enter")
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
