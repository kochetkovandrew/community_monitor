class Attachment < ActiveRecord::Base

  def self.from_entity(entity)
    attachments = []
    if entity.raw['attachments']
      entity.raw['attachments'].each do |attachment|
        if attachment['type'] == 'photo'
          photo_size = 0
          link = ""
          attachment['photo'].each do |k, v|
            matches = /^photo_(\d+)/.match k
            if matches
              if matches[1].to_i > photo_size
                photo_size = matches[1].to_i
                link = v
              end
            end
          end
          existing_photo = Attachment.find_by_uri(link)
          if !existing_photo
            new_photo = Attachment.create(uri: link)
          end
          if !existing_photo || existing_photo.local_filename.nil?
            extname = File.extname(URI.parse(link).path)
            photo = existing_photo || new_photo
            begin
              File.open(Rails.root.join("attachments", photo.id.to_s + extname), "wb") do |saved_file|
                # the following "open" is provided by open-uri
                open(link, "rb") do |read_file|
                  saved_file.write(read_file.read)
                  sleep(0.35)
                end
              end
              photo.local_filename = photo.id.to_s + extname
              photo.save
              attachments.push photo
            rescue
              logger.error "Can't download \"" + link + "\""
            end
          end
        elsif attachment['type'] == 'doc'
          link = attachment['doc']['url']
          short_uri = link.gsub(/\?.*$/, '')
          existing_doc = Attachment.find_by_uri(short_uri)
          if !existing_doc
            new_doc = Attachment.create(uri: short_uri, title: attachment['doc']['title'])
          end
          if !existing_doc || existing_doc.local_filename.nil?
            extname = '.' + attachment['doc']['ext']
            doc = existing_doc || new_doc
            begin
              File.open(Rails.root.join("attachments", doc.id.to_s + extname), "wb") do |saved_file|
                # the following "open" is provided by open-uri
                open(link, "rb") do |read_file|
                  saved_file.write(read_file.read)
                  sleep(0.35)
                end
              end
              doc.local_filename = doc.id.to_s + extname
              doc.save
              attachments.push doc
            rescue => e
              logger.error e.message
              logger.error e.backtrace.join("\n")
              logger.error "Can't download \"" + link + "\""
            end
          end
        end
      end
    end
    attachments
  end


end
