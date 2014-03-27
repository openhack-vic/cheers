require "sse"

class UsersController < ApplicationController
  include ActionController::Live
  include ServerSide
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
    active_music = Music.where(user_id: active_user.id, is_current_theme: true).first
    if active_music
      active_user.is_active = true
      active_user.save!
      head :no_content
    else
      head :not_found
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
    sse = SSE.new(response.stream)
    begin
      song = Music.where(user_id: last_updated_user.id, is_current_theme: true).first
      if song
        sse.write({song: song.song, :load => load }, :event => "enter")
      end
    ensure
      sse.close
    end
  end

  private

end
