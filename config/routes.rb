# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :check_list do
  member do
    post 'update_progress'
  end
end
