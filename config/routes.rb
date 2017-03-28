Rails.application.routes.draw do

  resource :monotto_users do
    scope module: :monotto_users do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
      resources :financial_institutions
      resources :transfers
      resources :users, param: :bank_identifier
      resources :bank_admins
    end
  end

  resource :bank_admins, except: [:show, :update, :destroy, :create] do
    scope module: :bank_admins do
      post   "login"       => "sessions#create"
      delete "logout"      => "sessions#destroy"
      resources :users, param: :bank_identifier do
        scope module: :users do
          resources :demographics
          resources :transfers, except: [:show, :update, :destroy, :create]
          resources :goals
        end
      end
    end
  end
end
