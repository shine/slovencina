Slovencina::Application.routes.draw do
  devise_for :users, :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }

  resources :graphs
  resources :attempts
  resources :categories

  resources :words do  
    resource :statistic
  end
  resources :statistics
  
  get '/:controller(/:action(/:id))'

  root :to => 'statistics#index'
end