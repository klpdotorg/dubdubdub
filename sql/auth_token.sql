CREATE TABLE "authtoken_token" (
    "key" varchar(40) NOT NULL PRIMARY KEY,
    "user_id" integer NOT NULL UNIQUE REFERENCES "users_user" ("id") DEFERRABLE INITIALLY DEFERRED,
    "created" timestamp with time zone NOT NULL
)
;

