# Home Assistant Community Add-on: MongoDB

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Set a `admin_password` in the configuration.
2.  Start the "MongoDb Server" add-on.
3.  Check the logs of "MongoDB" to see if everything went well.

**Note**: The add-on is **pre-configured** out of the box! There is no need to add/change/update the server connection settings!

After starting the addon the connectionstring will be `mongodb://admin:<password>@<your-homeassistant-ip>:27017`. Default user is `admin`.

## Configuration

On first start, the add-on will copy its default configuration file to the `/homeassistant/addons/mongodb` folder. You can then modify the configuration by adding options to the configuration, for example with Visual Studio Code or any text editor.

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

``` yaml
server_name: homeassistant.local
log_level: warning
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

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
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `admin_password`

The `admin_password` option sets the password for the default `admin` user to access the MongoDB server. Make sure to choose a strong password to secure your database.

## Data folder

The addon will store most of its configuration in the `/data/mongodb` folder. Please ensure this is included in your backup.