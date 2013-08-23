Dummy::Application.routes.draw do
  root :to => 'home#index'

  get 'tests/:id', :to => 'tests#show'
end
