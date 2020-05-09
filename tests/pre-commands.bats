#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Records the start time of the command in an environment variable" {
  run "$PWD/hooks/pre-command"

  assert_success
  # Check that we produced the right output at least to the second
  assert_output --partial "Command started at $(date +%s)"
}
