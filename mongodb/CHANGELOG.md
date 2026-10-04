
## 0.1.1

### Add-on

- Restrict the temporary auth-initialization MongoDB instance to localhost only

### MongoDB

- Bundled MongoDB version remains in the 7.0 series

---

> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled MongoDB version.
> This release fixes the bootstrap security posture while continuing to bundle MongoDB 7.0.x.

## 0.1.0

### Add-on

- Move admin password initialization into a dedicated s6 oneshot service
- Render the runtime configuration from `/homeassistant/addons/mongodb/mongod.conf` into `/etc/mongodb/mongod.conf`
- Validate the required `admin_password` before startup and keep the default config in sync with the new layout

### MongoDB

- Bundled MongoDB version remains in the 7.0 series

---

> [!NOTE]
> The add-on uses semantic versioning and is independent of the bundled MongoDB version.
> This initial add-on release bundles MongoDB 7.0.x and the current startup/configuration flow.
