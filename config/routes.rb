Rails.application.routes.draw do

  resource :monotto_users do
    scope module: :monotto_users do
      post   "login"  => "sessions#create"
      delete "logout" => "sessions#destroy"
      resources :financial_institutions
      resources :transfers
      resources :users
      resources :goals
      resources :demographics
      resources :bank_admins
    end
  end

  post '/cron/get_transfer_information_for_users' => 'cron#get_transfer_information_for_users'

  resource :bank_admins, except: [:show, :update, :destroy, :create] do
    scope module: :bank_admins do
      post   "login"  => "sessions#create"
      delete "logout" => "sessions#destroy"
      resources :users, param: :bank_identifier do
        scope module: :users do
          resources :demographics
          resources :transfers, except: [:update, :destroy, :create]
          resources :goals
        end
      end
    end
  end
end
