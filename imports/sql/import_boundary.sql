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

UPDATE tb_boundary
SET status=2
WHERE id IN (SELECT id FROM ems_tb_boundary);

UPDATE tb_boundary
SET status=1
WHERE id NOT IN (SELECT id FROM ems_tb_boundary);
