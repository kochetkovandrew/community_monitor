class Photo < ActiveRecord::Base

  def self.from_entity(entity)
    photos = []
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
          existing_photo = Photo.find_by_uri(link)
          if !existing_photo
            extname = File.extname(URI.parse(link).path)
            photo = Photo.create(uri: link)
            File.open(Rails.root.join("attachments", photo.id.to_s + extname), "wb") do |saved_file|
              # the following "open" is provided by open-uri
              open(link, "rb") do |read_file|
                saved_file.write(read_file.read)
                sleep(0.35)
              end
            end
            photo.local_filename = photo.id.to_s + extname
            photo.save
            photos.push photo
          end
        end
      end
    end
    photos
  end

end
