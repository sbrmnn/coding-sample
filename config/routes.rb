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

  resource :vendors, except: [:create, :destroy, :show, :update] do
    post   "login"  => "sessions#create"
    delete "logout" => "sessions#destroy"
    scope module: :vendors do
      resource :me, only: :show, controller: :me
      resources :financial_institutions do
         scope module: :financial_institutions do
           resources :users, param: :token, only: [:create]
         end
      end
      resources :financial_institutions
      resources :users, param: :token do
        scope module: :users do
          resource  :balances, only: [:show]
          resources :goals
          resources :offer_messages, param: :offer_id, only: [:update]
          resources :offers, only: [:index, :show]
          resource  :settings, only: [:show, :update]
          resources :transfers, only: [:index]
        end
      end
    end
  end

  scope module: :bank_admins do
    post   "login"  => "sessions#create"
    delete "logout" => "sessions#destroy"
    resources :products do
      scope module: :products do
        resources :offers, only: [:index]
      end
    end
    resource :financial_institutions
    resources :xref_goal_types
    resources :ads
    resources :offers
    resources :products
    resources :historical_snapshots, only: [:index]
    resources :snapshots, only: [:index]
    resources :users, param: :bank_user_id do
        scope module: :users do
          #resources :offers
          resources :demographics
          resources :goals
        end
    end
  end
end
