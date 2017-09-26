Rails.application.routes.draw do

  resources :swaggers, :only => [:index]
  resource :monotto_users do
    scope module: :monotto_users do
      post   "login"  => "sessions#create"
      delete "logout" => "sessions#destroy"
      resources :financial_institutions
      resources :users
      resources :goals
      resources :demographics
      resources :bank_admins
    end
  end

  post '/cron/get_transfer_information_for_users' => 'cron#get_transfer_information_for_users'
  post '/cron/ground' => 'cron#ground'

  scope module: :bank_admins do
    post   "login"  => "sessions#create"
    delete "logout" => "sessions#destroy"
    resources :users, param: :bank_user_id do
        scope module: :users do
          resources :demographics
          resources :goals
        end
    end
  end
end
