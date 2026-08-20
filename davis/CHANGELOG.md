## 5.4.3

### Add-on

- Updated the Davis add-on to version 5.4.3

### Davis

- Shared calendars now inherit the calendar colour upon seeding
- Minor dependency updates

## 5.4.2

### Add-on

- Updated the Davis add-on to version 5.4.2

### Davis

- Dashboard fixes
- Bugfixes around user deletion

## 5.4.1

### Add-on

- Updated the Davis add-on to version 5.4.1

### Davis

- Fix subscriptions being deleted upon calendar deletion

## 5.4.0

### Add-on

- Updated the Davis add-on to version 5.4.0

### Davis

- Fix and improve the public calendar behaviour
- Refactor the birthday service for more robust synchronization
- Add a (limited) API endpoint
- Update to Symfony 7.4
- Dashboard URL parameters now use the internal user id

## 5.3.0

### Add-on

- Updated the Davis add-on to version 5.3.0

### Davis

- Replace the `php-imap` dependency
- Change the IMAP configuration to a new format

## 5.2.0

### Add-on

- Updated the Davis add-on to version 5.2.0

### Davis

- Add an automatic birthday calendar
- Update to Symfony 7.3
- Fix `X-Forwarded-*` header handling in the standalone Docker image
- Add `BIRTHDAY_REMINDER_OFFSET` env var (default `PT9H`)

## 5.1.3

### Add-on

- Updated the Davis add-on to version 5.1.3

### Davis

- Add a calendar public flag option
- Switch to `bigint` for occurrence timestamps
- Add `PUBLIC_CALENDARS_ENABLED` env var (default `true`)

## 5.1.2

### Add-on

- Updated the Davis add-on to version 5.1.2

### Davis

- Fix `.env` override
- Update the German translation

## 5.1.1

### Add-on

- Updated the Davis add-on to version 5.1.1

### Davis

- Fix shared calendar deletion when removing a user

## 5.1.0

### Add-on

- Updated the Davis add-on to version 5.1.0

### Davis

- Enable calendar subscriptions
- Allow configuring the TLS certificate checking policy
- Update sabre/dav to 4.7.0 and Symfony to 7.2
- Add `.well-known` redirects

---

> [!NOTE]
> The add-on version follows the [Davis version](https://github.com/tchapi/davis/releases).
> For detailed release notes, see the
> [official Davis changelog](https://github.com/tchapi/davis/blob/main/CHANGELOG.md).
