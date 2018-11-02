class AttachmentsController < ApplicationController

  before_action :authenticate_user!

  def show
    attachment = Attachment.find(params[:id])
    basename = File::basename(attachment.uri)
    mime_type = MIME::Types.type_for(basename).first.content_type
    filename = attachment.title || basename
    if /^image/.match mime_type
      send_file Rails.root.join('attachments', attachment.local_filename), :type => mime_type, :filename => filename, :disposition => :inline
    else
      send_file Rails.root.join('attachments', attachment.local_filename), :type => mime_type, :filename => filename
    end
  end
end
