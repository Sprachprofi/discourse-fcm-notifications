import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { htmlSafe } from "@ember/template";
import ConditionalLoadingSpinner from "discourse/components/conditional-loading-spinner";
import DButton from "discourse/components/d-button";
import { i18n } from "discourse-i18n";
import {
  subscribe as subscribeFcmNotification,
  unsubscribe as unsubscribeFcmNotification,
} from "discourse/plugins/discourse-fcm-notifications/discourse/lib/fcm-notifications";

export default class UserFcmNotificationInput extends Component {
  @service currentUser;
  @service siteSettings;

  @tracked loading = false;
  @tracked errorMessage = null;
  @tracked subscription = "";
  @tracked subscribed = !!this.currentUser.fcm_notifications_subscribed;

  get disabled() {
    return !this.subscription || this.loading;
  }

  setSubscribed(subscribed) {
    this.currentUser.set("fcm_notifications_subscribed", subscribed);
    this.subscribed = subscribed;
  }

  @action
  subscribe() {
    this.loading = true;
    this.errorMessage = null;
    subscribeFcmNotification(this.subscription)
      .then((response) => {
        if (response.success) {
          this.setSubscribed(true);
        } else {
          this.errorMessage = response.error;
        }
      })
      .finally(() => (this.loading = false));
  }

  @action
  unsubscribe() {
    this.loading = true;
    this.errorMessage = null;
    unsubscribeFcmNotification()
      .then((response) => {
        if (response.success) {
          this.setSubscribed(false);
        } else {
          this.errorMessage = response.error;
        }
      })
      .finally(() => (this.loading = false));
  }

  <template>
    {{#if this.siteSettings.fcm_notifications_enabled}}
      <div class="control-group fcm-notifications">
        <label class="control-label">
          {{i18n "discourse_fcm_notifications.title"}}
        </label>
        {{#if this.errorMessage}}
          <div class="alert alert-error">{{this.errorMessage}}</div>
        {{/if}}
        <div class="controls">
          <div>
            {{#if this.subscribed}}
              <DButton
                @icon="bell-slash"
                @label="discourse_fcm_notifications.disable"
                @action={{this.unsubscribe}}
                @disabled={{this.loading}}
              />
            {{else}}
              <Input
                @value={{this.subscription}}
                placeholder={{i18n
                  "discourse_fcm_notifications.api_key_placeholder"
                }}
                disabled={{this.loading}}
              />
              <DButton
                @icon="bell"
                @label="discourse_fcm_notifications.enable"
                @action={{this.subscribe}}
                @disabled={{this.disabled}}
              />
              <div class="instructions">
                {{htmlSafe (i18n "discourse_fcm_notifications.instructions")}}
              </div>
            {{/if}}
            <ConditionalLoadingSpinner
              @size="small"
              @condition={{this.loading}}
            />
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
