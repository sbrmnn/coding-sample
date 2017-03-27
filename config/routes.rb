Rails.application.routes.draw do

  resource :monotto_users do
    scope module: :monotto_users do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
      resources :goals
      resources :users, param: :bank_identifier do
        scope module: :users do
          resources :demographics
          resources :transfers
        end
      end
    end
  end

  resource :bank_admins do
    scope module: :bank_admins do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
      resources :goals
      resources :users, param: :bank_identifier do
        scope module: :users do
          resources :demographics
          resources :transfers
        end
      end
    end
  end

  resources :financial_institutions
end
