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
  include ActionController::Live
  before_filter :authenticate_user!, :except => [:listen, :trigger]
  skip_before_filter  :verify_authenticity_token

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @music = @user.songs
  end

  def trigger
    active_user = User.find(params[:user_id])
    if active_user
      active_user.is_active = true
      active_user.save!
    end
  end

  def listen
    load = false
    last_updated_user = User.order("updated_at").last
    if last_updated_user.is_active
      last_updated_user.is_active = false
      last_updated_user.save!
      load = true
    end
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ServerSide::SSE.new(response.stream)
    begin
      sse.write({song: Music.where(user_id: last_updated_user.id, is_current_theme: true).first.song, :load => load }, :event => "enter")
    rescue IOError
    ensure
      sse.close
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :name, :description, :email, :password, :password_confirmation, :current_password)
  end

end
