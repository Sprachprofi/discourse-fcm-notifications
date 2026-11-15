import { ajax } from "discourse/lib/ajax";

export function subscribe(subscription) {
  return ajax("/fcm_notifications/subscribe", {
    type: "POST",
    data: { subscription: subscription }
  });
}

export function unsubscribe() {
  return ajax("/fcm_notifications/unsubscribe", {
    type: "POST"
  });
}
