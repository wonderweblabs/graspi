Rails.application.routes.draw do

  get 'base', to: 'pages#base'
  get 'mixed', to: 'pages#mixed'
  get 'plain', to: 'pages#plain'

  root to: 'pages#base'

end