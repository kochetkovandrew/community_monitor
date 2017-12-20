class UploadsController < ApplicationController

  before_action :authenticate_user!

  def show
    upload = Upload.find(params[:id])
    send_file Rails.root.join('uploads', upload.id.to_s), :type => 'application/octet-stream', :filename => upload.file_name
  end
end
