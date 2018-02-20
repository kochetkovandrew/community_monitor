class UploadsController < ApplicationController

  before_action :authenticate_user!

  def show
    upload = Upload.find(params[:id])
    mime_type = MIME::Types.type_for(upload.file_name).first.content_type
    suffix = File.extname(upload.file_name)
    send_file Rails.root.join('uploads', 'file' + upload.id.to_s + suffix), :type => mime_type, :filename => upload.file_name
  end
end
