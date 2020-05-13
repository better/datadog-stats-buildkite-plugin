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
