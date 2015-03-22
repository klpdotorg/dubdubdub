\x
-- Boundary Create
SELECT count(*), array_to_string(array_agg(id), ',') as "Boundaries to create"
FROM ems_tb_boundary
WHERE id NOT IN
        (SELECT id
         FROM tb_boundary);

WITH ems_new_tb_boundary AS (
    SELECT *
    FROM ems_tb_boundary
    WHERE id NOT IN
            (SELECT id
             FROM tb_boundary)
    ORDER BY id
) INSERT INTO tb_boundary SELECT * FROM ems_new_tb_boundary;

-- Boundary Update
SELECT count(*), array_to_string(array_agg(id), ',') as "Boundaries to update"
from (SELECT ems_tb_boundary.id, ems_tb_boundary.name, parent_id, boundary_category_id, boundary_type_id
    from ems_tb_boundary LEFT JOIN tb_boundary on ems_tb_boundary.id=tb_boundary.id
    WHERE ems_tb_boundary.parent_id <> tb_boundary.parent OR
        ems_tb_boundary.name <> tb_boundary.name OR
        ems_tb_boundary.boundary_category_id <> tb_boundary.hid OR
        ems_tb_boundary.boundary_type_id <> tb_boundary.type) as ems_www_tb_boundary;

WITH ems_www_tb_boundary AS (
    SELECT ems_tb_boundary.id, ems_tb_boundary.name, parent_id, boundary_category_id, boundary_type_id
    from ems_tb_boundary LEFT JOIN tb_boundary on ems_tb_boundary.id=tb_boundary.id
    WHERE ems_tb_boundary.parent_id <> tb_boundary.parent OR
        ems_tb_boundary.name <> tb_boundary.name OR
        ems_tb_boundary.boundary_category_id <> tb_boundary.hid OR
        ems_tb_boundary.boundary_type_id <> tb_boundary.type
) UPDATE tb_boundary
SET parent=ems_www_tb_boundary.parent_id,
    name=ems_www_tb_boundary.name,
    hid=ems_www_tb_boundary.boundary_category_id,
    type=ems_www_tb_boundary.boundary_type_id
FROM ems_www_tb_boundary
WHERE tb_boundary.id=ems_www_tb_boundary.id;


-- Schools to create
SELECT count(*), array_to_string(array_agg(id), ',') as "Schools to create"
FROM ems_tb_school
WHERE id NOT IN
        (SELECT id
         FROM tb_school);

WITH ems_new_tb_school AS (
    SELECT id,
        boundary_id::integer as bid,
        inst_address_id::integer as aid,
        dise_code,
        inst_name as name,
        inst_category::school_category as cat,
        institution_gender::school_sex as sex,
        moi::school_moi,
        management::school_management as mgmt,
        active as status
    FROM ems_tb_school
    WHERE id NOT IN
            (SELECT id
             FROM tb_school)
    ORDER BY id
    LIMIT 1
) INSERT INTO tb_school SELECT * FROM ems_new_tb_school;


SELECT COUNT(*) AS "Schools to update" FROM
    (SELECT *
        FROM ems_tb_school
        WHERE moi IS NOT NULL
            AND id IN
                (SELECT id
                 FROM tb_school) EXCEPT
            SELECT id,
                   bid AS boundary_id,
                   aid::text AS inst_address_id,
                   dise_code,
                   name AS inst_name,
                   cat::text AS inst_category,
                   sex::text AS institution_gender,
                   moi::text,
                   mgmt::text AS management,
                   status AS active
            FROM tb_school) as ems_www_tb_school;
