#!/bin/bash

function getMetricName() {
  local BASE_METRIC_PATH=${BUILDKITE_PLUGIN_DATADOG_STATS_METRIC_PREFIX:-buildkite.steps}
  echo -n "${BASE_METRIC_PATH}.${1}"
}
