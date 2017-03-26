Rails.application.routes.draw do

  resource :monotto_users do
    scope module: :monotto_users do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
    end
  end

  resource :bank_admins do
    scope module: :bank_admins do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
      resources :users do
        scope module: :users do
          resource :transfers
        end
      end
    end
  end

  resources :financial_institutions
  resources :transfers
  resources :goals
  resources :users
end
