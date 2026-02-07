# automation_mface_TVS_config_UPDATE_PS

This PowerShell script updates the `password` field in the TVS configuration file while preserving the original JSON formatting.  
It also optionally commits and pushes the change to Git.

Target file (default):

C:\/...\MFace\conf\CBP\tvs-config.json

---

## Purpose

This tool exists to safely rotate the TVS password hash without:

- Reformatting JSON
- Introducing trailing newlines
- Breaking config structure
- Manually editing production files

It ensures consistency, auditability (via Git), and speed for operational updates.

---

## Features

- `password` update (no formatting changes)
- Prevents empty password entries
- No newline added at EOF
- Optional Git commit + push flow
- Default commit message included

---

## Requirements

- Windows PowerShell 5+ or PowerShell Core
- Git installed (optional for push flow)
- Access to the config directory
