--
-- Before running this sql, please run `python manage.py migrate schools`
--

CREATE EXTENSION pg_trgm;

-- DISTRICT ----------------------------
-- update primary district slugs - hid=9
----------------------------------------
SELECT set_limit(0.525);

CREATE MATERIALIZED VIEW mvw_dise_districts AS
SELECT t1.district, t1.slug
FROM dblink('host=localhost dbname=klpdise_olap user=klp'::text, 'select distinct district, slug from dise_1415_district_aggregations'::text) t1(district text, slug text);

UPDATE tb_boundary
SET dise_slug=t1.slug
FROM mvw_dise_districts t1
WHERE hid=9 AND lower(name)%lower(t1.district);

-- update boundaries that didnt match by name

UPDATE tb_boundary SET dise_slug='chikkamangalore' WHERE hid=9 AND name='chikmagalur';
UPDATE tb_boundary SET dise_slug='chamarajanagara' WHERE hid=9 AND name='chamrajnagar';
UPDATE tb_boundary SET dise_slug='uttara-kannada' WHERE hid=9 AND name='uttara kannada';

-- no slug should be set for bangalore, as there are 2 districts in DISE
-- for Bangalore. Bangalore U North and U South

UPDATE tb_boundary SET dise_slug = NULL WHERE id=8877;

-- BLOCK -------------------------------
-- update primary block slugs - hid=10
----------------------------------------
CREATE MATERIALIZED VIEW mvw_dise_blocks AS
SELECT t1.block_name, t1.district, t1.slug
FROM dblink('host=localhost dbname=klpdise_olap user=klp'::text, 'select block_name, district, slug from dise_1415_block_aggregations where block_name is not null'::text) t1(block_name text, district text, slug text);

-- select bdry.name, parent_bdry.name, t1.block_name, t1.district, t1.slug
UPDATE tb_boundary
SET dise_slug=t1.slug
from tb_boundary parent_bdry, mvw_dise_blocks t1, mvw_dise_districts t2
where tb_boundary.hid=10 and parent_bdry.id=tb_boundary.parent and t2.district=t1.district and t2.slug=parent_bdry.dise_slug and lower(tb_boundary.name) % lower(t1.block_name);

UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-mundagod' WHERE hid=10 and name='mundagod';
UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-joida' WHERE hid=10 and name='joida';
UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-haliyal' WHERE hid=10 and name='haliyal';
UPDATE tb_boundary SET dise_slug='bangalore-u-south-anekal' WHERE hid=10 and name='anekal';
UPDATE tb_boundary SET dise_slug=NULL WHERE hid=10 and name='bmp-1';
UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-sirsi' WHERE hid=10 and name='sirsi';
UPDATE tb_boundary SET dise_slug=NULL WHERE hid=10 and name='hdmc';
UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-siddapur' WHERE hid=10 and name='siddapur';
UPDATE tb_boundary SET dise_slug='uttara-kannada-sirsi-yellapur' WHERE hid=10 and name='yellapur';
UPDATE tb_boundary SET dise_slug='bangalore-u-north-north1' WHERE hid=10 and name='north-1';
UPDATE tb_boundary SET dise_slug='bangalore-u-north-north2' WHERE hid=10 and name='north-2';
UPDATE tb_boundary SET dise_slug='bangalore-u-north-north3' WHERE hid=10 and name='north-3';
UPDATE tb_boundary SET dise_slug='bangalore-u-north-north4' WHERE hid=10 and name='north-4';
UPDATE tb_boundary SET dise_slug='bangalore-u-south-south1' WHERE hid=10 and name='south-1';
UPDATE tb_boundary SET dise_slug='bangalore-u-south-south2' WHERE hid=10 and name='south-2';
UPDATE tb_boundary SET dise_slug='bangalore-u-south-south3' WHERE hid=10 and name='south-3';
UPDATE tb_boundary SET dise_slug='bangalore-u-south-south4' WHERE hid=10 and name='south-4';

-- CLUSTER -----------------------------
-- update primary cluster slugs - hid=11
----------------------------------------
CREATE EXTENSION pg_similarity;

CREATE MATERIALIZED VIEW mvw_dise_clusters AS
SELECT t1.cluster_name, t1.block_name, t1.district, t1.slug
FROM dblink(
    'host=localhost dbname=klpdise_olap user=klp'::text,
    'select cluster_name, block_name, district, slug from dise_1415_cluster_aggregations where cluster_name is not null'::text
) t1(cluster_name text, block_name text, district text, slug text);

UPDATE tb_boundary
SET dise_slug=t1.slug
from tb_boundary parent_bdry, mvw_dise_clusters t1, mvw_dise_blocks t2
where
    tb_boundary.hid=11 and
    parent_bdry.id=tb_boundary.parent and
    t2.block_name=t1.block_name and
    t2.slug=parent_bdry.dise_slug and
    lower(tb_boundary.name) % lower(t1.cluster_name);

UPDATE tb_boundary
SET dise_slug=t1.slug
from tb_boundary parent_bdry, mvw_dise_clusters t1, mvw_dise_blocks t2
where
    tb_boundary.dise_slug is null and
    tb_boundary.hid=11 and
    parent_bdry.id=tb_boundary.parent and
    t2.block_name=t1.block_name and
    t2.slug=parent_bdry.dise_slug and
    jarowinkler(lower(tb_boundary.name), lower(t1.cluster_name)) >= 0.85;

----------------------------------------
------------- CLEAN UP -----------------
----------------------------------------
DROP MATERIALIZED VIEW mvw_dise_districts;
DROP MATERIALIZED VIEW mvw_dise_blocks;
DROP MATERIALIZED VIEW mvw_dise_clusters;
