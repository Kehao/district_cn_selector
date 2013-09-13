Dummy::Application.routes.draw do
  if DistrictCnSelector.rails4?
    root :to => 'home#rails4'
  else
    root :to => 'home#index'
  end
  post 'home/valid',:to => 'home#valid'
end
