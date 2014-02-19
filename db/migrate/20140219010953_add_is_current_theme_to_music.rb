class AddIsCurrentThemeToMusic < ActiveRecord::Migration
  def change
    add_column :musics, :is_current_theme, :boolean, :default => false
  end
end
