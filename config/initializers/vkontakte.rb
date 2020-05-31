def vk_lock
  File.open(Rails.root.join('tmp', 'vk.lock'), File::RDWR|File::CREAT, 0644) do |f|
    f.flock(File::LOCK_EX)
    res = yield
    sleep 0.35
    f.flock(File::LOCK_UN)
    return res
  end
end

def vk_renew_lock
  File.open(Rails.root.join('tmp', 'vk_renew.lock'), File::RDWR|File::CREAT, 0644) do |f|
    f.flock(File::LOCK_EX)
    res = yield
    f.flock(File::LOCK_UN)
    return res
  end
end

VkontakteApi.configure do |config|
  # параметры, необходимые для авторизации средствами vkontakte_api
  # (не нужны при использовании сторонней авторизации)
  config.app_id       = Rails.application.credentials.vk[:app_id]
  config.app_secret   = Rails.application.credentials.vk[:app_secret]
  config.redirect_uri = 'https://api.vkontakte.ru/blank.html'

  # faraday-адаптер для сетевых запросов
  config.adapter = :net_http
  # HTTP-метод для вызова методов API (:get или :post)
  config.http_verb = :post
  # параметры для faraday-соединения
  config.faraday_options = {
    ssl: {
      ca_path:  '/usr/lib/ssl/certs'
    },
    # proxy: {
    #   uri:      'http://proxy.example.com',
    #   user:     'foo',
    #   password: 'bar'
    # }
  }
  # максимальное количество повторов запроса при ошибках
  # работает только если переключить http_verb в :get
  config.max_retries = 2

  # логгер
  config.logger        = Rails.logger
  config.log_requests  = true  # URL-ы запросов
  config.log_errors    = true  # ошибки
  config.log_responses = false # удачные ответы

  # используемая версия API
  config.api_version = '5.60'
end
