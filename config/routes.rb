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

  resources :vendors, param: :public_key, except: [:index, :create, :destroy, :show, :update] do
    scope module: :vendors do
      resources :users, param: :bank_user_id do
        scope module: :users do
          resources :goals
          resources :offers
          resources :transactions
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
          resources :offers
          resources :demographics
          resources :goals
        end
    end
  end
end
