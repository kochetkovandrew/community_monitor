Rails.application.routes.draw do
  devise_for :users

  resources :communities
  get 'members/:id/friends' => 'members#friends'
  get 'members/:id/comments' => 'members#comments'
  resources :members
  get 'wall-69659144_113021' => 'test#test'
  get 'nonprogressors' => 'test#test'
  get 'slow' => 'test#test2'

  get 'users/profile' => 'users#profile'
  post 'members/check' => 'members#check'

  get 'community_member_histories/:id/diff' => 'community_member_histories#diff'
  get 'community_member_histories/:id' => 'community_member_histories#show'
  get 'submit_news' => 'submit_news#new'
  post 'submit_news' => 'submit_news#create'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'communities#index'

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
