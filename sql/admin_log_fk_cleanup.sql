ALTER TABLE ONLY django_admin_log
    DROP CONSTRAINT django_admin_log_user_id_fkey;
ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES users_user(id) DEFERRABLE INITIALLY DEFERRED;
