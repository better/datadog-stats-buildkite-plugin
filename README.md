# Datadog Stats Buildkite Plugin

Collects detailed stats about step runtimes and reports them to datadog.
Sends the following metrics for the step:

* `buildkite.steps.step.duration` - Distribution metric of the duration of the entire step
* `buildkite.steps.checkout.duration` - Distrubution metric of the duration of the checkout
* `buildkite.steps.command.duration` - Distrubution metric of the duration of the command

By default this tags each of those metrics with the following tags:

* `is_master` - Whether or not this branch is `master`
* `pipeline_slug` - The pipeline slug for the pipeline this step is running in
* `step_label` - The label used for this particular step
* `retry_count` - The current retry count
* `agent_queue` - The queue that the agent who ran this job came from

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ls
    plugins:
      - better/datadog-stats#v1.0.0:
          dogstatsd_host: 'localhost'
```

### Example of using additional tags

This example assumes you set the `PROJECT` environment variable to
something useful on your agents prior to the `post-checkout` step. And
will add the tags `project:<your PROJECT env var>` and
`hard_coded_value:some_string` to all the metrics.

```yml
steps:
  - command: ls
    plugins:
      - better/datadog-stats#v1.0.0:
          dogstatsd_host: 'localhost'
          additional_tags:
            - tag: project
              env_var: PROJECT
            - tag: hard_coded_value
              value: some_string
```

## Configuration

### `dogstatsd_host` (Required, string)

The host where this agent can reach a running instance of dogstatsd for
reporting metrics to.

### `dogstatsd_port` (Optional, string)

The port where this agent can reach dogstatsd on wherever is specified
in `dogstatsd_host`. This defaults to the default port for dogstatsd
which is `8125`.

### `metric_prefix` (Optional, string)

The base part of the metric that the plugin will report to datadog. This
defaults to `buildkite.steps`.

### `additional_tags` (Optional, array)

This is an array of additional tags you want to send and where to find
them in the environment variables. Each entry is an object with
properties

* `tag` which is the tag name to send to datadog
* `env_var` which is the environment variable to pull the tag's value from
* `value` which is a static value to send for that tag

## Developing

To run the tests:

```shell
docker-compose run --rm tests
```

To run shellcheck:

```shell
docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable hooks/** lib/**
```

## Contributing

1. Fork the repo
2. Make the changes
3. Run the tests
4. Commit and push your changes
5. Send a pull request
