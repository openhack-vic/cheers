class AddSongToMusic < ActiveRecord::Migration
  def change
    add_column :musics, :song, :string
  end
end
