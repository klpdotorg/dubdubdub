UPDATE "tb_school" SET "status" = 0 WHERE UPPER("tb_school"."name"::text) LIKE UPPER('%DELETE%');
UPDATE "tb_school" SET "status" = 0 WHERE UPPER("tb_school"."name"::text) LIKE UPPER('%test%');
UPDATE "tb_school" SET "status" = 0 WHERE UPPER("tb_school"."name"::text) LIKE UPPER('%tst%');
UPDATE "tb_school" SET "status" = 0 WHERE UPPER("tb_school"."name"::text) LIKE UPPER('%tset%');
UPDATE "tb_school" SET name=regexp_replace(name, E'\t', '', 'g') WHERE name LIKE E'%\t%';
UPDATE "tb_school" SET name=regexp_replace(name, '\s+', ' ', 'g') WHERE name LIKE E'%  %';
UPDATE "tb_school" SET "status" = 0 WHERE "tb_school"."name" IN ('1', '2');