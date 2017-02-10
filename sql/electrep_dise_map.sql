-- This needs to be run on the electrep_new database
-- it'll create the column for dise_slug on tb_electedrep_master table
-- and fill it up with slugs form dise
create extension pg_similarity;
alter table tb_electedrep_master add column dise_slug text;

-----------------------------------------------------
-------------       ASSEMBLY       ------------------
-----------------------------------------------------

create materialized view mvw_dise_assembly as
select t.assembly_name, t.slug from
dblink('host=localhost dbname=klpdise_olap user=klp'::text,
    'select assembly_name, slug from dise_1415_assembly_aggregations'::text)
    t(assembly_name text, slug text);

-- select const_ward_type, const_ward_name, mvw_dise_assembly.assembly_name, mvw_dise_assembly.slug
-- from tb_electedrep_master
-- left outer join mvw_dise_assembly on (
--     jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) = 1
-- )
-- where const_ward_type='MLA Constituency' and status='active' and dise_slug is null
-- order by const_ward_name;

update tb_electedrep_master
set
    dise_slug=mvw_dise_assembly.slug
from mvw_dise_assembly
where jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) = 1 and
    const_ward_type='MLA Constituency' and
    status='active' and
    dise_slug is null;

drop materialized view mvw_dise_assembly;

-----------------------------------------------------
------------       PARLIAMENT       -----------------
-----------------------------------------------------

create materialized view mvw_dise_parliament as
select t.parliament_name, t.slug from
dblink('host=localhost dbname=klpdise_olap user=klp'::text,
    'select parliament_name, slug from dise_1415_parliament_aggregations'::text)
    t(parliament_name text, slug text);

-- select const_ward_type, const_ward_name, mvw_dise_parliament.parliament_name, mvw_dise_parliament.slug
-- from tb_electedrep_master
-- left outer join mvw_dise_parliament on (
--     jarowinkler(upper(const_ward_name), upper(mvw_dise_parliament.parliament_name)) > 0.95
-- )
-- where const_ward_type='MP Constituency' and status='active' and dise_slug is null
-- order by const_ward_name;

update tb_electedrep_master
set
    dise_slug=mvw_dise_parliament.slug
from mvw_dise_parliament
where jarowinkler(upper(const_ward_name), upper(mvw_dise_parliament.parliament_name)) = 1 and
    const_ward_type='MP Constituency' and
    status='active' and
    dise_slug is null;

drop materialized view mvw_dise_parliament;