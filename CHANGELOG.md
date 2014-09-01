How to deploy
---
Use required commands

    fab dev deploy
    fab dev deploy:migrate=True
    fab dev deploy:pip_install=True
    fab dev deploy:pip_install=True,migrate=True

Changelog
---
Release 0.5:
  - Added materialized view for MDM agg [run-sql]

Release 0.4: August 31: 66b43577d76b4c5514ef7c7774a12ee78484b413
  - Added materialized view for inst coords and added index to facility_agg [run-sql]

Release 0.3.1: August 26: 048f9bc41fa80dc3d46038171e4a0ec329f35712
  - OmniSearch box on map page works
  - Optimize some point loading behaviour on map page
  - Set page title on marker popups

Release 0.3: August 25: f826aa24958f6150da974961a0ce1f921a323525
 - Updated Django version to 1.7c2 [pip-install]
 - Added django-compressor for js / css minification [pip-install]
 - Modified SchoolDetails Materialized View [run-sql]
 - Added materialized view for total students per class per year [run-sql]
 - Stabilized front-end framework.
 - Router methods, map layers and events.
 - School page with limited features.

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
