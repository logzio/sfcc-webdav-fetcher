# Logz.io Logs for Salesforce Commerce Cloud

A Docker image purpose-built to monitor Salesforce Commerce Cloud (fka Demandware) logs

## Usage

1. Use the following docker command to run your container

```sh
docker pull logzio/webdav-fetcher:latest
```

2. Use the following docker command to run your container.

```sh
docker run -d -e "LOGZIO_SHIPPING_KEY=<logzio_shipping_token>" -e "SFCC_HOSTNAME=<your_sfcc_host>" -e "SFCC_CLIENT_ID=<your_sfcc_client_id> -e SFCC_CLIENT_SECRET=<your_sfcc_client_secret> -e LOGZIO_LISTENER_URL=<logzio_listener_url> logzio/webdav-fetcher:latest
```

- If you prefer to store these environment variables in a file like [this example](./variables.env), you can run docker like so:

```sh
docker run -d --env-file=variables.env logzio/webdav-fetcher:latest
```

## License

Logz.io Logs for Salesforce Commerce Cloud is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
