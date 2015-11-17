Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'map#show'
   get 'search' => 'map#search'
  get 'related_to/:id' => 'map#show_related_conflicts'

end
