class RenameAccessTokenCopyDialogs < ActiveRecord::Migration[5.0]
  def change
    rename_column :copy_dialogs, :access_key, :access_token
  end
end
