Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects, only: %i(index create update destroy) do
        resources :tasks, only: %i(index create update)
      end
    end
  end
end
