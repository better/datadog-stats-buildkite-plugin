# Datadog Stats Buildkite Plugin

Collects detailed stats about step runtimes and reports them to datadog

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - command: ls
    plugins:
      - better/datadog-stats#v1.0.0:
        dogstatsd_host: 'localhost'
```

## Configuration

### `dogstatsd_host` (Required, string)

The host where this agent can reach a running instance of dogstatsd for
reporting metrics to.

### `dogstatsd_port` (Optional, string)

The port where this agent can reach dogstatsd on wherever is specified
in `dogstatsd_host`. This defaults to the default port for dogstatsd
which is `8125`.

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

## Contributing

1. Fork the repo
2. Make the changes
3. Run the tests
4. Commit and push your changes
5. Send a pull request
