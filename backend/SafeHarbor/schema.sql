-- ==========================================================
-- 1. DROP TABLES (Reverse order of dependencies)
-- ==========================================================
DROP TABLE IF EXISTS "users" CASCADE;
DROP TABLE IF EXISTS "public_impact_snapshots" CASCADE;
DROP TABLE IF EXISTS "social_media_posts" CASCADE;
DROP TABLE IF EXISTS "safehouse_monthly_metrics" CASCADE;
DROP TABLE IF EXISTS "safehouse_staff" CASCADE;
DROP TABLE IF EXISTS "resident_partners" CASCADE;
DROP TABLE IF EXISTS "home_visitations" CASCADE;
DROP TABLE IF EXISTS "process_recordings" CASCADE;
DROP TABLE IF EXISTS "intervention_plans" CASCADE;
DROP TABLE IF EXISTS "health_wellbeing_records" CASCADE;
DROP TABLE IF EXISTS "incident_reports" CASCADE;
DROP TABLE IF EXISTS "residents" CASCADE;
DROP TABLE IF EXISTS "safehouses" CASCADE;
DROP TABLE IF EXISTS "partners" CASCADE;
DROP TABLE IF EXISTS "staff_members" CASCADE;
DROP TABLE IF EXISTS "locations" CASCADE;
DROP TABLE IF EXISTS "status_states" CASCADE;
DROP TABLE IF EXISTS "roles" CASCADE;

-- ==========================================================
-- CREATE TABLES (Parent tables first)
-- ==========================================================

-- ==========================================================
-- 1. LOOKUP & INFRASTRUCTURE TABLES (5 Tables)
-- ==========================================================

-- Table 1: roles
CREATE TABLE "roles" (
    "role_id" SERIAL PRIMARY KEY,
    "role_name" VARCHAR(50) NOT NULL
);

-- Table 2: status_states
CREATE TABLE "status_states" (
    "status_id" SERIAL PRIMARY KEY,
    "status_name" VARCHAR(50) NOT NULL
);

-- Table 3: locations
CREATE TABLE "locations" (
    "location_id" SERIAL PRIMARY KEY,
    "location_name" VARCHAR(100) NOT NULL,
    "address" TEXT
);

-- Table 4: staff_members
CREATE TABLE "staff_members" (
    "staff_id" SERIAL PRIMARY KEY,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "role_id" INTEGER REFERENCES "roles"("role_id"),
    "location_id" INTEGER REFERENCES "locations"("location_id")
);

-- Table 5: partners
CREATE TABLE "partners" (
    "partner_id" SERIAL PRIMARY KEY,
    "partner_name" VARCHAR(255),
    "partner_type" VARCHAR(50),
    "role_type" VARCHAR(100),
    "contact_name" VARCHAR(255),
    "email" VARCHAR(255),
    "phone" VARCHAR(50),
    "region" VARCHAR(100),
    "status" VARCHAR(50),
    "start_date" DATE,
    "end_date" DATE,
    "notes" TEXT
);

-- ==========================================================
-- 2. CORE ENTITY TABLES (2 Tables)
-- ==========================================================

-- Table 6: safehouses
CREATE TABLE "safehouses" (
    "safehouse_id" SERIAL PRIMARY KEY,
    "safehouse_code" VARCHAR(20) UNIQUE,
    "name" VARCHAR(255) NOT NULL,
    "region" VARCHAR(100),
    "city" VARCHAR(100),
    "province" VARCHAR(100),
    "country" VARCHAR(100),
    "open_date" DATE,
    "status" VARCHAR(50),
    "capacity_girls" INTEGER,
    "capacity_staff" INTEGER,
    "current_occupancy" INTEGER,
    "notes" TEXT
);

-- Table 7: residents
CREATE TABLE "residents" (
    "resident_id" SERIAL PRIMARY KEY,
    "case_control_no" VARCHAR(50) UNIQUE,
    "internal_code" VARCHAR(50),
    "safehouse_id" INTEGER REFERENCES "safehouses"("safehouse_id"),
    "case_status" VARCHAR(50),
    "sex" CHAR(1),
    "date_of_birth" DATE,
    "birth_status" VARCHAR(50),
    "place_of_birth" VARCHAR(255),
    "religion" VARCHAR(100),
    "case_category" VARCHAR(100),
    "sub_cat_orphaned" BOOLEAN,
    "sub_cat_trafficked" BOOLEAN,
    "sub_cat_child_labor" BOOLEAN,
    "sub_cat_physical_abuse" BOOLEAN,
    "sub_cat_sexual_abuse" BOOLEAN,
    "sub_cat_osaec" BOOLEAN,
    "sub_cat_cicl" BOOLEAN,
    "sub_cat_at_risk" BOOLEAN,
    "sub_cat_street_child" BOOLEAN,
    "sub_cat_child_with_hiv" BOOLEAN,
    "is_pwd" BOOLEAN,
    "pwd_type" VARCHAR(100),
    "has_special_needs" BOOLEAN,
    "special_needs_diagnosis" TEXT,
    "family_is_4ps" BOOLEAN,
    "family_solo_parent" BOOLEAN,
    "family_indigenous" BOOLEAN,
    "family_parent_pwd" BOOLEAN,
    "family_informal_settler" BOOLEAN,
    "date_of_admission" DATE,
    "age_upon_admission" VARCHAR(50),
    "present_age" VARCHAR(50),
    "length_of_stay" VARCHAR(100),
    "referral_source" VARCHAR(255),
    "referring_agency_person" VARCHAR(255),
    "date_colb_registered" DATE,
    "date_colb_obtained" DATE,
    "assigned_social_worker" VARCHAR(100),
    "initial_case_assessment" TEXT,
    "date_case_study_prepared" DATE,
    "reintegration_type" VARCHAR(100),
    "reintegration_status" VARCHAR(100),
    "initial_risk_level" VARCHAR(50),
    "current_risk_level" VARCHAR(50),
    "date_enrolled" DATE,
    "date_closed" DATE,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "notes_restricted" TEXT
);

-- ==========================================================
-- 3. CASE TRACKING & CLINICAL (5 Tables)
-- ==========================================================

-- Table 8: incident_reports
CREATE TABLE "incident_reports" (
    "incident_id" SERIAL PRIMARY KEY,
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "safehouse_id" INTEGER REFERENCES "safehouses"("safehouse_id"),
    "incident_date" DATE,
    "incident_type" VARCHAR(100),
    "severity" VARCHAR(50),
    "description" TEXT,
    "response_taken" TEXT,
    "resolved" BOOLEAN,
    "resolution_date" DATE,
    "reported_by" VARCHAR(100),
    "follow_up_required" BOOLEAN
);

-- Table 9: health_wellbeing_records
CREATE TABLE "health_wellbeing_records" (
    "health_record_id" SERIAL PRIMARY KEY,
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "record_date" DATE,
    "general_health_score" DECIMAL,
    "nutrition_score" DECIMAL,
    "sleep_quality_score" DECIMAL,
    "energy_level_score" DECIMAL,
    "height_cm" DECIMAL,
    "weight_kg" DECIMAL,
    "bmi" DECIMAL,
    "medical_checkup_done" BOOLEAN,
    "dental_checkup_done" BOOLEAN,
    "psychological_checkup_done" BOOLEAN,
    "notes" TEXT
);

-- Table 10: intervention_plans
CREATE TABLE "intervention_plans" (
    "plan_id" SERIAL PRIMARY KEY,
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "plan_category" VARCHAR(100),
    "plan_description" TEXT,
    "services_provided" TEXT,
    "target_value" DECIMAL,
    "target_date" DATE,
    "status" VARCHAR(50),
    "case_conference_date" DATE,
    "created_at" TIMESTAMP,
    "updated_at" TIMESTAMP
);

-- Table 11: process_recordings
CREATE TABLE "process_recordings" (
    "recording_id" SERIAL PRIMARY KEY,
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "session_date" DATE,
    "social_worker" VARCHAR(100),
    "session_type" VARCHAR(50),
    "session_duration_minutes" INTEGER,
    "emotional_state_observed" VARCHAR(100),
    "emotional_state_end" VARCHAR(100),
    "session_narrative" TEXT,
    "interventions_applied" TEXT,
    "follow_up_actions" TEXT,
    "progress_noted" BOOLEAN,
    "concerns_flagged" BOOLEAN,
    "referral_made" BOOLEAN,
    "notes_restricted" TEXT
);

-- Table 12: home_visitations
CREATE TABLE "home_visitations" (
    "visitation_id" SERIAL PRIMARY KEY,
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "visit_date" DATE,
    "social_worker" VARCHAR(100),
    "visit_type" VARCHAR(100),
    "location_visited" VARCHAR(255),
    "family_members_present" TEXT,
    "purpose" TEXT,
    "observations" TEXT,
    "family_cooperation_level" VARCHAR(50),
    "safety_concerns_noted" BOOLEAN,
    "follow_up_needed" BOOLEAN,
    "follow_up_notes" TEXT,
    "visit_outcome" VARCHAR(100)
);

-- ==========================================================
-- 4. MAPPING & MANY-TO-MANY (2 Tables)
-- ==========================================================

-- Table 13: resident_partners (Linking residents to specific partners)
CREATE TABLE "resident_partners" (
    "resident_id" INTEGER REFERENCES "residents"("resident_id"),
    "partner_id" INTEGER REFERENCES "partners"("partner_id"),
    PRIMARY KEY ("resident_id", "partner_id")
);

-- Table 14: safehouse_staff (Linking staff to safehouses)
CREATE TABLE "safehouse_staff" (
    "safehouse_id" INTEGER REFERENCES "safehouses"("safehouse_id"),
    "staff_id" INTEGER REFERENCES "staff_members"("staff_id"),
    PRIMARY KEY ("safehouse_id", "staff_id")
);

-- ==========================================================
-- 5. OPERATIONS, ANALYTICS & CONTENT (3 Tables)
-- ==========================================================

-- Table 15: safehouse_monthly_metrics
CREATE TABLE "safehouse_monthly_metrics" (
    "metric_id" SERIAL PRIMARY KEY,
    "safehouse_id" INTEGER REFERENCES "safehouses"("safehouse_id"),
    "month_start" DATE,
    "month_end" DATE,
    "active_residents" INTEGER,
    "avg_education_progress" DECIMAL,
    "avg_health_score" DECIMAL,
    "process_recording_count" INTEGER,
    "home_visitation_count" INTEGER,
    "incident_count" INTEGER,
    "notes" TEXT
);

-- Table 16: social_media_posts
CREATE TABLE "social_media_posts" (
    "post_id" SERIAL PRIMARY KEY,
    "platform" VARCHAR(50),
    "platform_post_id" VARCHAR(100),
    "post_url" TEXT,
    "created_at" TIMESTAMP,
    "day_of_week" VARCHAR(20),
    "post_hour" INTEGER,
    "post_type" VARCHAR(50),
    "media_type" VARCHAR(50),
    "caption" TEXT,
    "hashtags" TEXT,
    "num_hashtags" INTEGER,
    "mentions_count" INTEGER,
    "has_call_to_action" BOOLEAN,
    "call_to_action_type" VARCHAR(100),
    "content_topic" VARCHAR(100),
    "sentiment_tone" VARCHAR(50),
    "caption_length" INTEGER,
    "features_resident_story" BOOLEAN,
    "campaign_name" VARCHAR(255),
    "is_boosted" BOOLEAN,
    "boost_budget_php" DECIMAL,
    "impressions" INTEGER,
    "reach" INTEGER,
    "likes" INTEGER,
    "comments" INTEGER,
    "shares" INTEGER,
    "saves" INTEGER,
    "click_throughs" INTEGER,
    "video_views" INTEGER,
    "engagement_rate" DECIMAL,
    "profile_visits" INTEGER,
    "donation_referrals" INTEGER,
    "estimated_donation_value_php" DECIMAL,
    "follower_count_at_post" INTEGER,
    "watch_time_seconds" INTEGER,
    "avg_view_duration_seconds" INTEGER,
    "subscriber_count_at_post" INTEGER,
    "forwards" INTEGER
);

-- Table 17: public_impact_snapshots
CREATE TABLE "public_impact_snapshots" (
    "snapshot_id" SERIAL PRIMARY KEY,
    "snapshot_date" DATE,
    "headline" VARCHAR(255),
    "summary_text" TEXT,
    "metric_payload_json" TEXT,
    "is_published" BOOLEAN,
    "published_at" DATE
);

CREATE TABLE "users" (
    "user_id" SERIAL PRIMARY KEY,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) UNIQUE NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "role_id" INTEGER REFERENCES "roles"("role_id"),
    "is_active" BOOLEAN DEFAULT TRUE,
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "last_login" TIMESTAMP
);