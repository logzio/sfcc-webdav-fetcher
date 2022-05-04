# Logz.io Logs for Salesforce Commerce Cloud

This is a Docker image that is purpose-built to monitor Salesforce Commerce Cloud (fka Demandware) logs.

## Usage

### 1. Pull the Docker image

Donwload the logzio/webdav-fetcher image:

```sh
docker pull logzio/webdav-fetcher:latest
```

### 2. Run the container

Use the following Docker command to run your container.

```sh
docker run -d -e LOGZIO_SHIPPING_TOKEN=<logzio_shipping_token>  \
-e LOGZIO_LISTENER_URL=<logzio_listener_url> \
-e SFCC_HOSTNAME=<your_sfcc_host> \
-e SFCC_CLIENT_ID=<your_sfcc_client_id> \
-e SFCC_CLIENT_SECRET=<your_sfcc_client_secret> \
logzio/webdav-fetcher:latest
```

| Parameter             | Description                                                                                                                                                                                                                                                                                                                                   | Required |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------: |
| LOGZIO_LISTENER_URL   | Determines protocol, listener host, and port. For example, https://<<LOGZIO_LISTENER_URL>>:8071.Replace <<LOGZIO_LISTENER_URL>> with your region's listener host (for example, listener.logz.io). For more information on finding your account's region, see [Account region](https://docs.logz.io/user-guide/accounts/account-region.html) . |      Yes |
| LOGZIO_SHIPPING_TOKEN | The [token](https://app.logz.io/#/dashboard/settings/general) of the account you want to ship to.                                                                                                                                                                                                                                             |      Yes |
| SFCC_HOSTNAME         | Hostname from the host that need to send logs from (ex. dev01-mysandbox.demandware.net)                                                                                                                                                                                                                                                                |      Yes |
| SFCC_CLIENT_ID        | Client id related to the account from where need to send logs. [Learn more](https://documentation.b2c.commercecloud.salesforce.com/DOC3/index.jsp?topic=%2Fcom.demandware.dochelp%2Fcontent%2Fb2c_commerce%2Ftopics%2Faccount_manager%2Fb2c_account_manager_add_api_client_id.html)                                                           |      Yes |
| SFCC_CLIENT_SECRET    | Client secret related to the account from where need to send logs. [Learn more](https://documentation.b2c.commercecloud.salesforce.com/DOC3/index.jsp?topic=%2Fcom.demandware.dochelp%2Fcontent%2Fb2c_commerce%2Ftopics%2Faccount_manager%2Fb2c_account_manager_add_api_client_id.html)                                                       |      Yes |

If you prefer to store these environment variables in a file like [this](./variables.env), you can run Docker as follows:

```sh
docker run -d --env-file=variables.env logzio/webdav-fetcher:latest
```

### 3. Grok patterns

You can manage grok patterns based on log types using [fluentD-grok-parser](fluent-plugin-grok-parser).

The following log types are available: `analytics`, `api`, `codeprofiler`, `console`, `customdebug`, `customerror`, `customfatal`, `custominfo`, `customwarn`, `debug`, `deprecation`, `error`, `fatal`, `info`, `jobs`, `migration`, `performance`, `quota`, `sql`, `staging`, `sysevent`, `syslog`, `warn`

You can download a sample list of grok patterns (`example.grokPatternList.json`) to the folder where you run the docker image and then specify grok patterns based on the log types. For example:

```
 "debug": [
        "pattern ^%{LOGLEVEL:level} %{WORD:servlet}\\|%{NUMBER}\\|%{DATA:sitename}\\|%{DATA:action}\\|%{WORD:pipeline}\\|%{DATA:sessionid} %{DATA} %{DATA} %{DATA} %{DATA} %{DATA} %{DATA} %{DATA}\\s+%{WTF}?%{GREEDYDATA:message}"
    ]
```

### 4. Apply grok patterns

To apply grok patterns, you need to mount `grokPatternList.json` file to the image

```sh
docker run -d -e LOGZIO_SHIPPING_TOKEN=<logzio_shipping_token>  \
-v $(pwd)/example.grokPatternsList.json:/grokPatternsList.json
-e LOGZIO_LISTENER_URL=<logzio_listener_url> \
-e SFCC_HOSTNAME=<your_sfcc_host> \
-e SFCC_CLIENT_ID=<your_sfcc_client_id> \
-e SFCC_CLIENT_SECRET=<your_sfcc_client_secret> \
logzio/webdav-fetcher:latest
```

## Change log

-   1.1.0:
    -   Option to manage grok patterns via JSON file.
-   1.0.0:
    -   Docker based solution
    -   Collect and sends webdav logs

## License

Logz.io Logs for Salesforce Commerce Cloud is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
