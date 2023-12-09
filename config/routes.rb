DiscourseFcmNotifications::Engine.routes.draw do
  get '/automatic_subscribe' => 'push#automatic_subscribe'
  post '/subscribe' => 'push#subscribe'
  post '/unsubscribe' => 'push#unsubscribe'
end

Discourse::Application.routes.draw do
  mount ::DiscourseFcmNotifications::Engine, at: '/fcm_notifications'
end