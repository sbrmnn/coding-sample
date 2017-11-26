Rails.application.routes.draw do
  get "/" => redirect("https://monotto.com")
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


  scope module: :bank_admins do
    post   "login"  => "sessions#create"
    delete "logout" => "sessions#destroy"
    resource :financial_institutions
    resources :xref_goal_types
    resources :ads
    resources :offers
    resources :products
    resources :historical_snapshots, only: [:index]
    resources :snapshots, only: [:index]
    resources :products do
      scope module: :products do
        resources :offers, only: [:index]
      end
    end
    resources :users, param: :bank_user_id do
        scope module: :users do
          resources :messages
          resources :demographics
          resources :goals
        end
    end
  end
end
