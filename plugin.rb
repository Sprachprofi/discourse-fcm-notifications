# frozen_string_literal: true

# name: discourse-fcm-notifications
# about: Plugin for integrating firebase notifications to a custom app
# version: 0.2.0
# authors: Judith Meyer, Jeff Wong (original plugin: discourse-pushover-notifications)
# url: https://github.com/sprachprofi/discourse-fcm-notifications

enabled_site_setting :fcm_notifications_enabled

# Discourse installs plugin gems one at a time without resolving dependencies,
# so every dependency Discourse does not bundle itself must be listed here,
# before the gem that needs it. (faraday, jwt, addressable and base64 come
# from Discourse.)
gem 'pstore', '0.2.1'
gem 'os', '1.1.4'
gem 'google-cloud-env', '2.4.1', require: false
gem 'google-logging-utils', '0.2.2', require: false
gem 'signet', '0.22.2'
gem 'googleauth', '1.17.7'
gem 'fcm', '1.0.8'

module ::DiscourseFcmNotifications
  PLUGIN_NAME = "discourse-fcm-notifications"
  #autoload :Pusher, "#{Rails.root}/plugins/discourse-fcm-notifications/services/discourse_fcm_notifications/pusher"
end

require_relative "lib/discourse_fcm_notifications/engine"

after_initialize do
  User.register_custom_field_type(DiscourseFcmNotifications::PLUGIN_NAME, :json)
  allow_staff_user_custom_field DiscourseFcmNotifications::PLUGIN_NAME

  # Tells the logged-in user's own client whether they have a device token
  # stored, without sending the token itself.
  add_to_serializer(:current_user, :fcm_notifications_subscribed) do
    object.custom_fields[DiscourseFcmNotifications::PLUGIN_NAME].present?
  end

  DiscourseEvent.on(:push_notification) do |user, payload|
    if SiteSetting.fcm_notifications_enabled?
      Jobs.enqueue(:send_fcm_notifications, user_id: user.id, payload: payload)
    end
  end

  #DiscourseEvent.on(:user_logged_out) do |user|
  #  if SiteSetting.fcm_notifications_enabled?
  #    DiscourseFcmNotifications::Pusher.unsubscribe(user)
  #    user.save_custom_fields(true)
  #  end
  #end

  require_dependency 'jobs/base'
  module ::Jobs
    class SendFcmNotifications < ::Jobs::Base
      def execute(args)
        return unless SiteSetting.fcm_notifications_enabled?

        user = User.find(args[:user_id])
        DiscourseFcmNotifications::Pusher.push(user, args[:payload])
      end
    end
  end
end
