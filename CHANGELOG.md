How to deploy
---
Use required commands

    fab dev deploy
    fab dev deploy:migrate=True
    fab dev deploy:pip_install=True
    fab dev deploy:pip_install=True,migrate=True

Changelog
---

Release 0.9: a35c01f81f74a65bb7013148e61586e600ab3adb
    - Fix several front-end issues, see issue tracker

Release 0.8: 88a6a92017a87ed1a782c898f765ac84fd089f0f
  - Permanent URLs for compare state
  - Several front-end fixes

Release 0.7:
  - Cleaned up SYS data [run-sql sys_cleanup.sql]
  - Add color field to volunteer activity types [sql-migrate]
  - Fixed foreignkey to auth_users on django_admin_log [run-sql admin_log_fk_cleanup.sql]

Release 0.6.1: September 24: <FILL IT>
  - added mviews for lib data [run-sql materialized_views_sep24.sql]

Release 0.6: September 23: 3c229cb1beb9408ba03113eecd36a77b9d4caadf
  - Added Anganwadi db as MView [run-sql]
  - Re-model donation work-flow [sql-migrate]
  - Added stories [run-sql sys_new_schemas.sql]
  - More front-end polish.

Release 0.5.1: September 3: d94e37756b64cf8df2ff290b7ff97bc870e84269
  - Update to django 1.7 [pip-install]
  - Compare modals

Release 0.5:
  - Added materialized view for MDM agg [run-sql]

Release 0.4.1: August 31: 0a83b5ad5b0f9d9d8eaee841d234ad2bcc933818
  - Responsive fixes.

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
 - User auth working [run-sql auth_token.sql]
 - Password reset API working
 - Added `is_active` to User model [migrate]
 - Added organization logo [migrate]
 - Re-organize / shorten URLs for users / volunteers end-points
 - Fix bug with new User sign-up
 - Avoid cascade delete for models where it should not apply

Release 0.1: July 8: a2b96f76527cbb01a491ba4f69b3a2c0444756d1
 - All endpoints working
 - Added Swager UI for API doc
