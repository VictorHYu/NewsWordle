Rails.application.routes.draw do
    get 'home/index'
    post 'home/load'
    root 'home#index'
end
