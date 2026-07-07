# Ebisu Store — New Arrivals Monitor

Checks https://www.ebisustore.com New Arrivals (category 148) every 10 minutes,
and alerts by **email** and **phone push (ntfy)** when new products appear.

## Files

| File | Purpose |
|---|---|
| `monitor.py` | The monitor script |
| `.env` | Your credentials — fill this in, never commit/share it |
| `state.json` | Previously-seen products (auto-created; delete to reset baseline) |
| `monitor.log` | History of every run |
| `run_monitor.bat` | What Task Scheduler runs every 10 minutes |

## One-time setup

### 1. Fill in `.env`

- `SUPPLIER_EMAIL` / `SUPPLIER_PASSWORD` — your ebisustore.com account login.
- `GMAIL_APP_PASSWORD` — see next section.
- `NTFY_TOPIC` — a random topic name is pre-filled; change it if you like.

### 2. Create a Gmail app password

Gmail blocks plain-password SMTP, so you need an "app password":

1. Go to https://myaccount.google.com/security and make sure
   **2-Step Verification is ON** (app passwords require it).
2. Go to https://myaccount.google.com/apppasswords
   (or search "app passwords" in the Google Account search bar).
3. Enter a name like `ebisu-monitor` and click **Create**.
4. Google shows a 16-character password like `abcd efgh ijkl mnop`.
   Copy it into `.env` as `GMAIL_APP_PASSWORD` (spaces are fine, but you can
   remove them). You won't be able to see it again — but you can always
   create a new one.

### 3. Subscribe your phone to ntfy

1. Install the **ntfy** app: [Android (Play Store)](https://play.google.com/store/apps/details?id=io.heckel.ntfy) / [iPhone (App Store)](https://apps.apple.com/us/app/ntfy/id1625396347).
2. Open the app → **+ (Subscribe to topic)**.
3. Type the exact topic name from your `.env` (`NTFY_TOPIC`), keep the default
   server `ntfy.sh`, and subscribe.
4. Done — no account needed. Anyone who knows the topic name can see the
   alerts, so keep it unguessable.

## Usage

```powershell
# Normal run (what the scheduler does every 10 min)
.venv\Scripts\python.exe monitor.py

# Send a test alert to email + phone
.venv\Scripts\python.exe monitor.py --test-alert
```

- **First run** just saves a baseline of current products — no alert.
- **New products** → immediate email + push with names, prices, links.
- **Login failure / page layout change** → one alert (not repeated every
  10 minutes); it re-arms after the monitor recovers.
- **Network blips** → logged, retried next run, never alerted.
- Check `monitor.log` for full history; `state.json` holds everything seen so far.

## Scheduling

A Windows Task Scheduler task named **EbisuNewArrivalsMonitor** runs
`run_monitor.bat` every 10 minutes, survives reboots, and needs no app open.

```powershell
# inspect / manage
schtasks /Query /TN EbisuNewArrivalsMonitor /V /FO LIST
schtasks /Run   /TN EbisuNewArrivalsMonitor    # trigger manually
schtasks /Delete /TN EbisuNewArrivalsMonitor /F  # remove
```
