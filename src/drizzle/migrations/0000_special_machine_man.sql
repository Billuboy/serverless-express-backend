DO $$ BEGIN
 CREATE TYPE "user_role_enum" AS ENUM('user', 'admin');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "users" (
	"id" serial PRIMARY KEY NOT NULL,
	"type" "user_role_enum" DEFAULT 'user',
	"email" varchar NOT NULL,
	"first_name" varchar NOT NULL,
	"last_name" varchar,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
