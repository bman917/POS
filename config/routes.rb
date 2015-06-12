Rails.application.routes.draw do

  get 'items/sales' => 'items#sales', as: 'sales'

  resources :item_prices

  get 'admin/reset_purchase_orders'

  resources :delivery_items do
    collection do
      get 'autocomplete'
      delete 'destroy_multiple'
    end
  end

  resources :deliveries

  resources :item_purchase_orders do
    collection do
      get 'autocomplete'
      delete 'destroy_multiple'
    end
  end

  resources :purchase_orders do
    member do
      get 'confirm'
      get 'pending'
    end
    collection do
      post 'add_items'
    end
  end

  resources :item_bases 

  get 'item_base/:id/attribs' => 'item_bases#scripts_to_add_attribs_to_item_form'

  get 'item_base/:id/attribs' => 'item_bases#scripts_to_add_attribs_to_item_form'

  get  'item/new/add/item_base' => 'item_bases#add_to_new_item_form', as: 'add_item_base_to_new_item_form'
  post 'item/new/add/item_base' => 'item_bases#script_to_add_to_select', as: 'item_base_script_to_add_to_select'
  get  'item/new/add/supplier' => 'suppliers#add_to_new_item_form', as: 'add_supplier_to_new_item_form'
  post 'item/new/add/supplier' => 'suppliers#script_to_add_to_select', as: 'supplier_script_to_add_to_select'
  get  'items/switch_supplier/:supplier_id' => 'items#index_switch_supplier', as: 'items_switch_supplier'

  resources :items do
    get  :json, on: :collection
    post :json, on: :collection
    get  :json_filter_by_supplier, on: :collection
    post :json_filter_by_supplier, on: :collection

    collection do
      post 'add_attrib'
      post 'create_similar'
      post 'set_multiple_price'
      delete 'destroy_multiple'
      get 'select'
      get 'autocomplete'
    end
    member do
      get 'copy'
    end
  end

  resources :suppliers

  resources :units

  resources :attribs do
    collection do
      get 'list'
    end
  end

  resources :categories

  get 'portal/index'

  mount UserManager::Engine, at: "/user_manager"
  # root "portal#index"
  root "items#index"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
