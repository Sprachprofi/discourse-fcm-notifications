module ::DiscourseFcmNotifications
  class PushController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    layout false
    before_action :ensure_logged_in
    skip_before_action :preload_json

    def automatic_subscribe
      DiscourseFcmNotifications::Pusher.subscribe(current_user, params[:token])
      if DiscourseFcmNotifications::Pusher.confirm_subscribe(current_user)
        #flash.now[:notice] = "You have successfully subscribed to push notifications."
        render json: success_json
      else
        #flash.now[:alert] = "There was an error subscribing to push notifications."
        render json: { failed: 'FAILED', error: I18n.t("discourse_fcm_notifications.subscribe_error") }
      end
      #redirect_to '/'
    end
    
    def subscribe
      DiscourseFcmNotifications::Pusher.subscribe(current_user, push_params)
      if DiscourseFcmNotifications::Pusher.confirm_subscribe(current_user)
        render json: success_json
      else
        render json: { failed: 'FAILED', error: I18n.t("discourse_fcm_notifications.subscribe_error") }
      end
    end

    def unsubscribe
      DiscourseFcmNotifications::Pusher.unsubscribe(current_user)
      render json: success_json
    end

    private

    def push_params
      params.require(:subscription)
    end
  end
end