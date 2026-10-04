# Home Assistant Community Add-on: MongoDB

Bundled MongoDB series: **7.0.x**

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a `admin_password` in the configuration.
2.  Start the "MongoDb Server" add-on.
3.  Check the logs of "MongoDB" to see if everything went well.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

After starting the addon the connection string will be `mongodb://admin:<password>@<your-homeassistant-ip>:27017`. Default user is `admin`.

## Configuration

On first start, the add-on copies its default configuration file to `/homeassistant/addons/mongodb/mongod.conf`. You can edit that file with Visual Studio Code or any text editor. On startup, the add-on renders the runtime config to `/etc/mongodb/mongod.conf`.

The admin password is not stored in that file. It is read from the add-on UI options and applied by a dedicated s6 initialization service before the main MongoDB service starts.

**Note**: _Restart the add-on after changing `/homeassistant/addons/mongodb/mongod.conf`._

Example add-on configuration:

``` yaml
log_level: warning
```

**Note**: _This is just an example for the add-on options, not for `mongod.conf`._

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `warning`.

### Option: `admin_password`

The `admin_password` option sets the password for the default `admin` user to access the MongoDB server. This option is required. Choose a strong unique password to secure your database.

## Data folder

MongoDB stores its database files in `/data/mongodb`. The editable server configuration lives in `/homeassistant/addons/mongodb/mongod.conf` and is rendered into `/etc/mongodb/mongod.conf` on every start.