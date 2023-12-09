# discourse-fcm-notifications
Plugin for having Discourse deliver push notifications to your custom iOS/Android app through Firebase.

This assumes you have a custom app that includes access to your Discourse forum. It won't work without such an app. If you don't have an app, try Discourse Pushover Notifications instead.

# Installation

See [the plugin install readme](https://meta.discourse.org/t/install-plugins-in-discourse/19157).

Once installed, you will need a Firebase token.

After you created the application, copy the resulting token to the Discourse admin plugin pages, and enable the plugin.

Users will be able to add their device keys in their preference -> Notifications.
