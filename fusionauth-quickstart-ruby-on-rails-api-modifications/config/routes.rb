Rails.application.routes.draw do
  resources :make_change, :path => '/make-change'
  resources :panic, :path => '/panic'
  resources :get_balance, :path => '/get-balance'
end
