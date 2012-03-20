Slovencina::Application.routes.draw do
  match '/' => 'statistics#index'
  resources :graphs
  resources :attempts
  resources :categories

  resources :words do  
    resource :statistic
  end
  resources :statistics
  
  match '/:controller(/:action(/:id))'
end