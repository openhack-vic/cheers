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
  
  def edit
    @music = Music.find(params[:id])
  end
  
  def update
    @music = Music.find(params[:id])
    
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to current_user, notice: "#{@music.title} is updated!" }
      else
        format.html { redirect_to edit_path, alert: "#{@music.title} was not updated. Please try again later."}
      end
    end
  end
  
  def destroy
    @music = Music.find(params[:id])
    @music.destroy
    
    redirect_to url_for(current_user)
  end
  
  private
  
  def music_params
    params.require(:music).permit(:title, :song)
  end
  
end
