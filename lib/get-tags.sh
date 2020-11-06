#!/bin/bash

function readAdditionalTags() {
  local result=()
  # Provide a limit to avoid accidental infinite loops
  for i in {0..100}; do
    tag_var="BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_${i}_TAG"
    env_var="BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_${i}_ENV_VAR"
    value_var="BUILDKITE_PLUGIN_DATADOG_STATS_ADDITIONAL_TAGS_${i}_VALUE"

    if [[ -z ${!tag_var:-} ]]; then
      result+=("")
      break;
    fi

    if [ -z ${!env_var:-} ]; then
      # If env_var is not set, then a hard-coded value must be
      result+=("${!tag_var}:${!value_var}")
    else
      local env_var_value=${!env_var}
      result+=("${!tag_var}:${!env_var_value:-}")
    fi
  done

  # shellcheck disable=SC2001
  echo -n "$(IFS=$','; echo "${result[*]}" | sed 's/,$//')"
}

function getTags() {
  BK_LABEL=${BUILDKITE_LABEL}
  BK_AGENT_QUEUE=${BUILDKITE_AGENT_META_DATA_QUEUE}

  IS_MASTER=false

  if [ "$BUILDKITE_BRANCH" == "master" ]; then
    IS_MASTER=true
  fi

  PIPELINE_SLUG=${BUILDKITE_PIPELINE_SLUG}
  RETRY_COUNT=${BUILDKITE_RETRY_COUNT:-0}
  ADDITIONAL_TAGS=$(readAdditionalTags)

  RESULT="is_master:${IS_MASTER},pipeline_slug:${PIPELINE_SLUG},step_label:${BK_LABEL},retry_count:${RETRY_COUNT},agent_queue:${BK_AGENT_QUEUE}"

  if [ -n "$ADDITIONAL_TAGS" ]; then
    RESULT+=",${ADDITIONAL_TAGS}"
  fi

  echo "${RESULT}"
}
