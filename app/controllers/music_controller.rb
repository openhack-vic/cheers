class MusicController < ApplicationController
  before_filter :authenticate_user!
  def upload_theme
    @music = Music.new
  end

  def upload
    @music = Music.new

    @music.song = params[:music][:song]
    @music.title = params[:music][:title]
    @music.is_current_theme = !params[:music][:is_current_theme].to_i.zero?
    @music.user_id = current_user.id

    if @music.is_current_theme
      falsify_all_others
    end

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

    params[:music][:is_current_theme] = !params[:music][:is_current_theme].to_i.zero?

    if params[:music][:is_current_theme]
      falsify_all_others
    end

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

    if @music.is_current_theme
      auto_current_music = Music.where("id != ? AND user_id = ?", @music.id, @music.user_id).first

      if auto_current_music
        auto_current_music.update_attribute(:is_current_theme, true)
      end

    end

    @music.destroy

    redirect_to url_for(current_user)
  end

  private

  def music_params
    params.require(:music).permit(:title, :song, :is_current_theme)
  end

  def falsify_all_others
    if @music.id
      Music.where("id != ? AND user_id = ? AND is_current_theme = 't'", @music.id, @music.user_id).update_all("is_current_theme = 'f'")
    else
      Music.where("user_id = ? AND is_current_theme = 't'", @music.user_id).update_all("is_current_theme = 'f'")
    end

  end

end
