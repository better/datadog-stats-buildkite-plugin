#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Records the start time of the step" {
  run "$PWD/hooks/environment"

  assert_success
  assert_output --partial "Step started at $(date +%s)"
}
