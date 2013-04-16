AsciiIo::Application.routes.draw do


  get "/browse" => "asciicasts#index", :as => :browse
  get "/browse/popular" => "asciicasts#popular", :as => :popular

  resources :asciicasts, :path => 'a' do
    resources :pictures
    member do
      get :raw
    end
  end


  #get "/~:id" => "users#show", :as => :profile

  get "/docs" => "docs#show", :page => 'record'
  get "/docs/:page" => "docs#show", :as => :docs


  get "/login" => "sessions#new"
  post "/login" => "sessions#auth"
  get "/logout" => "sessions#destroy"

  get "/connect/:user_token" => "user_tokens#create"

  resources :users ,:only =>[:new,:create]
  resource :user, :only => [:edit, :update]

  resources :liverooms

  namespace :api do
    resources :comments, :only => :destroy

    resources :asciicasts do
      resources :comments, :only => [:index, :create]
    end
  end

  root :to => 'home#show'

  mount JasmineRails::Engine => "/specs" unless Rails.env.production?

  match '*a', :to => 'application#not_found'
end
