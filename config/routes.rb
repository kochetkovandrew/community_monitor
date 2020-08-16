Rails.application.routes.draw do

  # resources :umfrages
  get 'umfrage' => 'umfrages#new'
  post 'umfrage' => 'umfrages#create'
  get 'umfrage/vielen_dank' => 'umfrages#vielen_dank'
  get 'umfrage_ergebnis' => 'umfrages#index'
  resources :vk_accounts
  resources :calendar2020s, except: [:edit]
  get 'calendar2020s/:day/edit' => 'calendar2020s#edit'

  resources :shortlinks
  resources :portal_attachments
  post 'copy_messages/archive' => 'copy_messages#archive'
  post 'community_keys' => 'community_keys#create'
  get 'vk_oauth/signin' => 'vk_oauth#signin'
  get 'vk_oauth/callback' => 'vk_oauth#callback'
  get 'short/:id' => 'shortlinks#short'
  resources :copy_dialogs, path: 'dialogs' do
    resources :copy_messages, only: [:index], path: 'messages'
  end
  resources :copy_messages
  resources :memory_dates
  resources :drug_groups
  resources :other_drugs
  resources :art_drugs
  devise_for :users

  resources :communities
  resources :news_requests
  resources :submit_news
  get '/posts/vk/:id' => 'posts#vk_view'
  resources :posts
  get '/topics/vk/:id' => 'topics#vk_view'
  resources :topics
  resources :wall, only: [:index]
  patch '/purge' => 'purge#update'
  resources :purge, only: [:index]

  get 'communities/:id/member_histories/report' => 'community_member_histories#report'
  get 'communities/:id/wall' => 'communities#wall'
  get 'communities/:id/topics' => 'communities#topics'
  get 'posts/:id/comments' => 'posts#comments'
  get 'topics/:id/comments' => 'topics#comments'
  get 'members/:id/friends' => 'members#friends'
  get 'members/:id/comments' => 'members#comments'
  get 'members/:id/likes' => 'members#likes'
  get 'members/:id/hidden_friends' => 'members#hidden_friends'
  get 'members/:id/history' => 'members#history'
  get 'uploads/:id' => 'uploads#show'
  get 'attachments/:id' => 'attachments#show'
  get 'frontpage' => 'frontpage#index'
  get 'druginteractions' => 'druginteractions#index'

  get 'apocalypse' => 'calendar2020s#vk_index'
  get 'mapocalypse' => 'calendar2020s#vk_index_mobile'

  resources :members

  get 'users/profile' => 'users#profile'
  put 'users/:id/assign_permission' => 'users#assign_permission'
  put 'users/:id/revoke_permission' => 'users#revoke_permission'
  resources :users

  post 'members/check' => 'members#check'

  get 'community_member_histories/:id/diff' => 'community_member_histories#diff'
  get 'community_member_histories/:id' => 'community_member_histories#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'frontpage#index'

end
