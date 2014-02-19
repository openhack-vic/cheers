class MusicController < ApplicationController
  before_filter :authenticate_user!
  def index
    @music = Music.new
  end
  
  def upload
    @music = Music.new
    
    @music.song = params[:music][:song]
    @music.title = params[:music][:title]
    @music.user_id = current_user.id
    
    respond_to do |format|
      if @music.save!
        format.html { redirect_to current_user, notice: 'You\'ve uploaded an entrance theme for yourself! Access it at: ' }
      else
        format.html { redirect_to upload_path, alert: 'Your theme wasn\'t saved. Please try again later.'}
      end
    end
  end
  
  private
  
  def user_params
    params.require(:music).permit(:title, :song)
  end
  
end
