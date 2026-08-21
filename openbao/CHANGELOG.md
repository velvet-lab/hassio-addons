## 2.6.2

### Add-on

- Initial release of the OpenBao add-on
- Install OpenBao via the official Debian package repository
- Add Web UI access on port 8200
- Automatically initialize OpenBao on first start and unseal on every start
- Persist unseal keys and root token in `/data/openbao/unseal.keys`
- Print the root token to the add-on log on first start
- Add a `config` option with a pre-filled default OpenBao configuration

### OpenBao

- Include security and bug fixes of the 2.6 series
- Enforce `allowed_ip_sans_cidr` on IP SANs from CSRs in the PKI secrets engine

---

> [!NOTE]
> The add-on version follows the [OpenBao version](https://openbao.org/).
> For detailed release notes, see the
> [official OpenBao changelog](https://github.com/openbao/openbao/blob/main/CHANGELOG.md).
