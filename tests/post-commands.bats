#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Creates an annotation with the file count" {
  NOW=$(date +%s%3N)
  export BUILDKITE_PLUGIN_DATADOG_STATS_COMMAND_START_TIME_MS=$(($NOW-900))

  run "$PWD/hooks/post-command"

  assert_success
  assert_output --partial "Total runtime 90"
}
