#!/bin/bash

set -euo pipefail


FAILURE=1
SUCCESS=0

CHANNEL_STAGING="deploy-staging"
WEBHOOK_STAGING="<WEBHOOK_URL>"

CHANNEL_PRODUCTION="deploy-production"
WEBHOOK_PRODUCTION="<WEBHOOK_URL>"

function print_slack_summary() {

    local slack_msg_header
    local slack_msg_body
    local slack_channel

    # Populate header and define slack channels

    slack_msg_header=":x: Deploy to ${ENVIRONMENT} failed"

    if [[ "${EXIT_STATUS}" == "${SUCCESS}" ]]; then
        slack_msg_header=":white_check_mark: Deploy to ${ENVIRONMENT} succeeded"
    fi


    if [[ "${ENVIRONMENT}" == "production" ]]; then
        slack_channel="$CHANNEL_PRODUCTION"
    else
        slack_channel="$CHANNEL_STAGING"
    fi

    # Create slack message body

    slack_msg_body="<https://REPO_URL|PLACEHOLDER> with job <https://REPO_URL/-/jobs/${CI_JOB_ID}|${CI_JOB_ID}> by ${GITLAB_USER_NAME} \n<https://REPO_URL/commit/$(git rev-parse HEAD)|$(git rev-parse --short HEAD)>\n - ${CI_COMMIT_REF_NAME} "
    
    cat <<-SLACK
            {
                "channel": "${slack_channel}",
                "blocks": [
                  {
                          "type": "section",
                          "text": {
                                  "type": "mrkdwn",
                                  "text": "${slack_msg_header}"
                          }
                  },
                  {
                          "type": "divider"
                  },
                  {
                          "type": "section",
		                  "text": {
                                  "type": "mrkdwn",
                                  "text": "${slack_msg_body}"
                          }
                  }
                ]
}
SLACK
}

function share_slack_update() {

	local slack_webhook
    
    if [[ "${ENVIRONMENT}" == "production" ]]; then
        slack_webhook="$WEBHOOK_PRODUCTION"
    else
        slack_webhook="$WEBHOOK_STAGING"
    fi

    curl -X POST                                           \
        --data-urlencode "payload=$(print_slack_summary)"  \
        "${slack_webhook}"
}
