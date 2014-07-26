How to deploy
---
Use required commands

    fab dev deploy
    fab dev deploy:migrate=True
    fab dev deploy:pip_install=True
    fab dev deploy:pip_install=True,migrate=True

Changelog
---
Release 0.3:
 - <add things here>

Release 0.2: July 26: 5c28f9cbc1aad0d1653401c671285012fd6fa882
 - User auth working
 - Password reset API working
 - Added `is_active` to User model [migrate]
 - Added organization logo [migrate]
 - Re-organize / shorten URLs for users / volunteers end-points
 - Fix bug with new User sign-up
 - Avoid cascade delete for models where it should not apply

Release 0.1: July 8: a2b96f76527cbb01a491ba4f69b3a2c0444756d1
 - All endpoints working
 - Added Swager UI for API doc
