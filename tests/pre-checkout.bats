#!/usr/bin/env bats

load "$BATS_PATH/load.bash"

@test "Records the start time of the checkout" {
  run "$PWD/hooks/pre-checkout"

  assert_success
  assert_output --partial "Checkout started at $(date +%s)"
}
