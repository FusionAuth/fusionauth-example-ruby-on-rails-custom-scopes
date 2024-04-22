Rails.application.routes.draw do
  get 'balance_budget', to: "balance_budget#index"
  get 'bb_login', to: "bb_login#index"
  get 'bb_logout', to: 'bb_logout#index'
  get 'get_balance', to: 'get_balance#index'
  get 'auth/:provider/callback', to: 'auth#callback'
  get '/auth/failure', to: 'sessions#failure'
  get 'logout', to: 'auth#logout'
  get '/login', to: 'get_balance#index'
  root to: 'home#index'
end
