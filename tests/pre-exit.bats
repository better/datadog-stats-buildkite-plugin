#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Sets the correct tags and runtime for the master branch" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_STEP_START_TIME_MS=$((NOW-900))
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"
  export BUILDKITE_AGENT_META_DATA_QUEUE="default"

  run "$PWD/hooks/pre-exit"

  assert_success
  assert_output --partial "Reporting buildkite.steps.step.duration with value=90"
  assert_output --partial "tags=is_master:true,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
  unset BUILDKITE_AGENT_META_DATA_QUEUE
}
