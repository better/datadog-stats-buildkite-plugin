function getTags() {
  BK_COMMAND=${BUILDKITE_COMMAND}
  BK_LABEL=${BUILDKITE_LABEL}

  IS_MASTER=false

  if [ "$BUILDKITE_BRANCH" == "master" ]; then
    IS_MASTER=true
  fi

  PIPELINE_SLUG=${BUILDKITE_PIPELINE_SLUG}
  RETRY_COUNT=${BUILDKITE_RETRY_COUNT:-0}

  echo is_master:${IS_MASTER},pipeline_slug:${PIPELINE_SLUG},step_command:${BK_COMMAND},step_label:${BK_LABEL},retry_count:${RETRY_COUNT}
}
