Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ru/ do
    # Маршруты аутентификации.
    resources :registrations, only: %i[new create]
    resource :session, only: %i[new create destroy]

    # Профиль текущего пользователя.
    resource :profile, only: %i[show], controller: :users

    # Основные ресурсы предметной области.
    resources :themes, only: %i[index show] do
      resources :images, only: %i[show]
    end

    resources :evaluations, only: %i[create]

    # Простое API для работы с изображениями и оценками.
    namespace :api do
      resources :themes, only: [] do
        resources :images, only: %i[index]
      end

      resources :images, only: [] do
        resources :evaluations, only: %i[create]
      end
    end

    root "themes#index"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/") outside locale scope (редиректим на локализованный root).
  # root "themes#index"
end
