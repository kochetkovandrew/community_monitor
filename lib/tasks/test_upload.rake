task test_upload: :environment do
  peer_id = 4048980
  vk = VkontakteApi::Client.new Settings.vk.user_access_token
  us = vk.docs.get_messages_upload_server(type: 'doc', peer_id: peer_id)
  upload_file = VkontakteApi.upload(url: us[:upload_url], file: [Rails.root.join('lib', 'tasks', 'test_upload.rake').to_s, 'application/octet-stream'])
  doc = vk.docs.save(
    file: upload_file[:file],
    title: 'test_upload.rake',
  )
  vk.messages.send(user_id: peer_id, message: 'Тестовое сообщение', attachment: ('doc' + doc[0].owner_id.to_s + '_' + doc[0].id.to_s))

end