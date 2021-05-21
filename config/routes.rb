Rails.application.routes.draw do
  root to: 'hospitals#index'
  resources  :hospitals
end
