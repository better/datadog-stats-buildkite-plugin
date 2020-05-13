#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Sets the correct tags and runtime for the master branch" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$(($NOW-900))
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Reporting buildkite.steps.duration as 90"
  assert_output --partial "tags is_master:true,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
}

@test "Sets the correct tags and runtime for a non-master branch" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$(($NOW-900))
  export BUILDKITE_BRANCH=some-branch
  export BUILDKITE_PIPELINE_SLUG=monorepo
  export BUILDKITE_COMMAND="cd somewhere && make do-something"
  export BUILDKITE_LABEL=":shipit: deploy-prod"

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Reporting buildkite.steps.duration as 90"
  assert_output --partial "tags is_mster:false,pipeline_slug:monorepo,step_command:cd somewhere && make do-something,step_label::shipit: deploy-prod,retry_count:0"

  unset BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS
  unset BUILDKITE_BRANCH
  unset BUILDKITE_PIPELINE_SLUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_LABEL
}
