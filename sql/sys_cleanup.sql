update stories_question set school_type = 2 where id in (63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86);
update stories_question set school_type = 1 where id in (46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 87, 88, 89, 90, 91, 92);
UPDATE "stories_question" SET "is_active" = false WHERE "stories_question"."id" IN (47, 48, 59, 61, 62, 70, 82, 83);
