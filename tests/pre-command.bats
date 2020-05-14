#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Records the start time of the command in an environment variable" {
  run "$PWD/hooks/pre-command"

  assert_success
  assert_output --partial "Command started at $(date +%s)"
}
