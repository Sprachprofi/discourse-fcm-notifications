import { default as discourseComputed } from "discourse-common/utils/decorators";
import Component from "@ember/component";
import { empty, or } from '@ember/object/computed';

import {
  subscribe as subscribeFcmNotification,
  unsubscribe as unsubscribeFcmNotification
} from "discourse/plugins/discourse-fcm-notifications/discourse/lib/fcm-notifications";

export default Component.extend({
  @discourseComputed
  showFcmNotification() {
    return this.siteSettings.fcm_notifications_enabled;
  },

  has_subscription: empty("subscription"),
  disabled: or("has_subscription", "loading"),
  loading: false,
  errorMessage: null,

  calculateSubscribed() {
    this.set(
      "fcmNotificationSubscribed",
      this.currentUser.custom_fields.discourse_fcm_notifications !=
        null
    );
  },

  fcmNotificationSubscribed: null,

  init() {
    this._super(...arguments);
    this.setProperties({
      fcmNotificationSubscribed:
        this.currentUser.custom_fields
          .discourse_fcm_notifications != null,
      errorMessage: null
    });
  },

  actions: {
    subscribe() {
      this.setProperties({
        loading: true,
        errorMessage: null
      });
      subscribeFcmNotification(this.subscription)
        .then(response => {
          if (response.success) {
            this.currentUser.custom_fields.discourse_fcm_notifications = this.subscription;
            this.calculateSubscribed();
          } else {
            this.set("errorMessage", response.error);
          }
        })
        .finally(() => this.set("loading", false));
    },

    unsubscribe() {
      this.setProperties({
        loading: true,
        errorMessage: null
      });
      unsubscribeFcmNotification()
        .then(response => {
          if (response.success) {
            this.currentUser.custom_fields.discourse_fcm_notifications = null;
            this.calculateSubscribed();
          } else {
            this.set("errorMessage", response.error);
          }
        })
        .finally(() => this.set("loading", false));
    }
  }
});
