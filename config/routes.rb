Rails.application.routes.draw do
  resources :copy_messages
  resources :memory_dates
  resources :drug_groups
  resources :other_drugs
  resources :art_drugs
  devise_for :users

  resources :communities
  resources :news_requests
  resources :submit_news

  get 'members/:id/friends' => 'members#friends'
  get 'members/:id/comments' => 'members#comments'
  get 'uploads/:id' => 'uploads#show'
  get 'frontpage' => 'frontpage#index'
  get 'druginteractions' => 'druginteractions#index'

  resources :members
  get 'wall-69659144_113021' => 'test#test'
  get 'nonprogressors' => 'test#test'
  get 'slow' => 'test#test2'
  get 'clinic' => 'test#test3'
  get '29zVZbLSERI' => 'test#test4'
  get 'toksichnost' => 'test#test5'
  get 'social-networks-73875' => 'test#test6'

  get 'users/profile' => 'users#profile'
  put 'users/:id/assign_permission' => 'users#assign_permission'
  put 'users/:id/revoke_permission' => 'users#revoke_permission'
  resources :users

  post 'members/check' => 'members#check'

  get 'community_member_histories/:id/diff' => 'community_member_histories#diff'
  get 'community_member_histories/:id' => 'community_member_histories#show'
  # get 'submit_news' => 'submit_news#index'
  # get 'submit_news/new' => 'submit_news#new'
  # post 'submit_news' => 'submit_news#create'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'frontpage#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
