# discourse-fcm-notifications
Plugin for having Discourse deliver push notifications to your custom iOS/Android app through Firebase.

This assumes you have a custom app that includes access to your Discourse forum. It won't work without such an app. If you don't have an app, try Discourse Pushover Notifications instead.

# Installation

See [the plugin install readme](https://meta.discourse.org/t/install-plugins-in-discourse/19157).

Create a Google Firebase project for your app. Add the Firebase project ID, token and the json (with OAuth data) to the plugin settings in your Discourse installation.

Users will be able to add their device keys in their preference -> Notifications. We recommend that your app include a way to copy the device key and to paste it into the right field without much searching.

# Receiving push notifications in your app

The push notifications that this app creates will include:

````
'data': {
  "linked_obj_type" => 'link',
  "linked_obj_data" => <url to the post/message referenced in the message>,
},
'notification': {
  title: <something like "USERNAME sent you a private message in TOPIC">,
  body: <beginning of the message>,
}
````

So you need to display the push notification with title/body and tapping on it should open the URL from linked_obj_data in an in-app browser. 
