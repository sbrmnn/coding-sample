Rails.application.routes.draw do

  resources :swaggers, :only => [:index]
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
  post '/cron/ground' => 'cron#ground'

  resource :bank_admins, except: [:show, :update, :destroy, :create] do
    scope module: :bank_admins do
      post   "login"  => "sessions#create"
      delete "logout" => "sessions#destroy"
      resources :users, param: :bank_identifier 
    end
  end

  resources :users, param: :bank_identifier, :only => [] do # We don't want unscoped user resource endpoints, hence the only hash points to no actions.
    scope module: :bank_admins do
      scope module: :users do
        resources :demographics
        resources :transfers, except: [:update, :destroy, :create]
        resources :goals
      end
    end
  end
end
