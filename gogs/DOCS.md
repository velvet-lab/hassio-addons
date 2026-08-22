# Home Assistant Community Add-on: Gogs

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1.  Start the "Gogs" add-on.
2.  Check the logs of "Gogs" to see if everything went well.

After starting the add-on, Gogs is available on port `3000` of your Home Assistant instance. The first visit shows the Gogs install wizard, which lets you create the administrator account. Whoever signs up while there are no other users becomes the admin.

## Configuration

The add-on is **pre-configured** out of the box with a SQLite database, so it does not require any external database service.

### Option: `log_level`

The `log_level` option controls the level of log output by the add-on and can be changed to be more or less verbose, which might be useful when you are dealing with an unknown issue. Possible values are:

*   `trace`: Show every detail, like all called internal functions.
*   `debug`: Shows detailed debug information.
*   `info`: Normal (usually) interesting events.
*   `warning`: Exceptional occurrences that are not errors.
*   `error`: Runtime errors that do not require immediate action.
*   `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a more severe level, e.g., `debug` also shows `info` messages. By default, the `log_level` is set to `info`, which is the recommended setting unless you are troubleshooting.

### Option: `secret_key`

The `secret_key` option is **required**: Gogs uses it to encrypt cookie values, two-factor authentication codes and similar sensitive data. Provide a strong, random value — for example generated with:

```
openssl rand -hex 32
```

This produces a 64-character hexadecimal key (256 bits). Home Assistant stores it encrypted. It must match the `[security] SECRET_KEY` value in the editable Gogs configuration file described below.

## Configuration

The Gogs server configuration is managed as a file on your Home Assistant configuration folder:

`/homeassistant/addons/gogs/gogs.ini`

On first start the add-on copies a default configuration there, which you can edit directly (for example with Visual Studio Code). Gogs uses the INI format; see the [Gogs configuration documentation](https://gogs.io/docs/use/configuration.html) for all available options.

The web server listens on `0.0.0.0` on its default port `3000`. The port shown in the add-on configuration is only the *exposed* port that Home Assistant forwards to the add-on; it does not change where Gogs itself listens. The `EXTERNAL_URL` and `DOMAIN` settings control the public URL used for login redirects and clone URLs. If you access the add-on from a different host than the one running Home Assistant (for example through a reverse proxy), update those values to match the address you use in the browser.

**Note:** Remember to restart the add-on after changing this file for the new configuration to take effect.

## Data folder

The add-on stores the Gogs data in the `/data/gogs` folder: the SQLite database, repositories, sessions and the generated secret key. Please ensure this is included in your backup.

## First steps

- On first start the add-on generates a `SECRET_KEY` and logs it to the add-on log.
- Open the Gogs web interface on port `3000` and complete the install wizard to create the administrator account.
- Use the web interface to create repositories; clone/push works over HTTP and HTTPS using the `EXTERNAL_URL`.