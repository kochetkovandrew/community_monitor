class RenameAccessTokenCopyDialogs < ActiveRecord::Migration
  def change
    rename_column :copy_dialogs, :access_key, :access_token
  end
end
