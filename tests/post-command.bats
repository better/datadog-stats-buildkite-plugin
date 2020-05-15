#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Sets the correct tags and runtime for the master branch" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$((NOW-900))
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"
  export BUILDKITE_AGENT_META_DATA_QUEUE="default"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Reporting buildkite.steps.command.duration with value=90"
  assert_output --partial "tags=is_master:true,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
  unset BUILDKITE_AGENT_META_DATA_QUEUE
}

@test "Sets the correct tags and runtime for a non-master branch" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$((NOW-900))
  export BUILDKITE_BRANCH=some-branch
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"
  export BUILDKITE_AGENT_META_DATA_QUEUE="default"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Reporting buildkite.steps.command.duration with value=90"
  assert_output --partial "tags=is_master:false,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
  unset BUILDKITE_AGENT_META_DATA_QUEUE
}

@test "It supports specifying additional tags by value and env var" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$((NOW-900))
  export BUILDKITE_BRANCH=some-branch
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"
  export BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_0_TAG="my-tag"
  export BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_0_ENV_VAR="MY_ENV_VAR"
  export MY_ENV_VAR="my-tag-value"
  export BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_1_TAG="my-other-tag"
  export BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_1_VALUE="my-other-tag-value"
  export BUILDKITE_AGENT_META_DATA_QUEUE="default"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Reporting buildkite.steps.command.duration with value=90"
  assert_output --partial "tags=is_master:false,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0,agent_queue:default,my-tag:my-tag-value,my-other-tag:my-other-tag-value"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
  unset BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_0_TAG
  unset BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_0_ENV_VAR
  unset MY_ENV_VAR
  unset BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_1_TAG
  unset BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_1_VALUE
  unset BUILDKITE_AGENT_META_DATA_QUEUE
}
