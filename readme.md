# Custom Slack notification for Gitlab CI/CD pipelines

Gitlab provides a way to interact with Slack via the [Slack Notification Service](https://docs.gitlab.com/ee/user/project/integrations/slack.html).

For those like us who would like to receive some notifications after a deployment on a particular environment, check `script.sh`.

## How does it work ?

1. Create a [Incoming Webhooks](https://api.slack.com/messaging/webhooks) per channel you want to publish in.
2. Modify variables accordingly
	- CHANNEL_STAGING : The channel name used for staging.
	- WEBHOOK_STAGING : The webhook generated for staging.
	- CHANNEL_PRODUCTION : THe channel name used for production.
	- WEBHOOK_PRODUCTION : The webhook generated for production.
3. Add these functions and variables to your `gitlab-ci.yaml`