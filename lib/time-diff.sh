#!/bin/bash

function timeDiff() {
  START_TIME=$1
  NOW=$(date +%s%3N)

  echo -n $((NOW-START_TIME))
}
