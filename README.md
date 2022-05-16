# Logz.io Logs for Salesforce Commerce Cloud

This is a Docker image that is purpose-built to monitor Salesforce Commerce Cloud (fka Demandware) logs.

## Usage

### 1. Pull the Docker image

Donwload the logzio/webdav-fetcher image:

```sh
docker pull logzio/sfcc-logs-fetcher:latest
```

### 2. Run the container

Use the following Docker command to run your container.

```sh
docker run -d -e LOGZIO_SHIPPING_TOKEN=<logzio_shipping_token>  \
-e LOGZIO_LISTENER_URL=<logzio_listener_url> \
-e SFCC_SERVER_NAME=<your_sfcc_host> \
-e SFCC_CLIENT_ID=<your_sfcc_client_id> \
-e SFCC_LOG_SOURCE=operational
-e SFCC_CLIENT_SECRET=<your_sfcc_client_secret> \
logzio/sfcc-logs-fetcher:latest
```

| Parameter             | Description                                                                                                                                                                                                                                                                                                                                   | Required |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------: |
| LOGZIO_LISTENER_URL   | Determines protocol, listener host, and port. For example, https://<<LOGZIO_LISTENER_URL>>:8071.Replace <<LOGZIO_LISTENER_URL>> with your region's listener host (for example, listener.logz.io). For more information on finding your account's region, see [Account region](https://docs.logz.io/user-guide/accounts/account-region.html) . |      Yes |
| LOGZIO_SHIPPING_TOKEN | The [token](https://app.logz.io/#/dashboard/settings/general) of the account you want to ship to.                                                                                                                                                                                                                                             |      Yes |
| SFCC_SERVER_NAME      | SFFC Server name from where you would like to collect logs.                                                                                                                                                                                                                                                                                   |      Yes |
| SFCC_CLIENT_ID        | Client id related to the account from where need to send logs. [Learn more](https://documentation.b2c.commercecloud.salesforce.com/DOC3/index.jsp?topic=%2Fcom.demandware.dochelp%2Fcontent%2Fb2c_commerce%2Ftopics%2Faccount_manager%2Fb2c_account_manager_add_api_client_id.html)                                                           |      Yes |
| SFCC_CLIENT_SECRET    | Client secret related to the account from where need to send logs. [Learn more](https://documentation.b2c.commercecloud.salesforce.com/DOC3/index.jsp?topic=%2Fcom.demandware.dochelp%2Fcontent%2Fb2c_commerce%2Ftopics%2Faccount_manager%2Fb2c_account_manager_add_api_client_id.html)                                                       |      Yes |
| SFCC_LOG_SOURCE       | Flag to represent which log types you would like to collect. `operational` - for operational logs, `security` for security logs, `all` for both of them.                                                                                                                                                                                      |      Yes |
| AUTO_PARSING          | Default: `false`. To enable auto parsing (by our prebuilt grok patterns ) set to `true`.                                                                                                                                                                                                                                                      |       No |

If you prefer to store these environment variables in a file like [this](./variables.env), you can run Docker as follows:

```sh
docker run -d --env-file=variables.env logzio/webdav-fetcher:latest
```

### 3. Grok patterns

Based on [fluentD-grok-parser](fluent-plugin-grok-parser) you have option to manage grok patterns base on log types.<br/>
Log types is: `analytics`, `api`, `codeprofiler`, `console`, `customdebug`, `customerror`, `customfatal`, `custominfo`, `customwarn`, `debug`, `deprecation`, `error`, `fatal`, `info`, `jobs`, `migration`, `performance`, `quota`, `sql`, `staging`, `sysevent`, `syslog`, `warn`,`service`, `syslog`

You can use our prebuilt grok patterns by setting the `AUTO_PARSING` environment variable to true. If you would like to define your own grok patterns you can do this by downloading the sample grok pattern file to the directory where you are running the docker image and edit it accordingly. For example:

```
     "service": [
        "pattern ^%{WORD:servlet}\\|%{NUMBER}\\|%{DATA:sitename}\\|%{DATA:action}\\|PipelineCall\\|%{DATA:sessionid} %{GREEDYDATA:msg}"
    ]
```

### 4. Apply grok patterns

To apply grok patterns, you need to mount `grokPatternList.json` file to the image:

```sh
docker run -d -e LOGZIO_SHIPPING_TOKEN=<logzio_shipping_token>  \
-v $(pwd)/example.grokPatternList.json:/grokPatternList.json
-e LOGZIO_LISTENER_URL=<logzio_listener_url> \
-e SFCC_SERVER_NAME=<your_sfcc_host> \
-e SFCC_CLIENT_ID=<your_sfcc_client_id> \
-e SFCC_CLIENT_SECRET=<your_sfcc_client_secret> \
logzio/sfcc-logs-fetcher:latest
```

## Change log

-   1.1.0:
    -   Option to manage grok patterns via JSON file.
-   1.0.0:
    -   Docker based solution
    -   Collect and sends webdav logs

## License

Logz.io Logs for Salesforce Commerce Cloud is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
