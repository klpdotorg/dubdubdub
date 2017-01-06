-- This needs to be run on the electrep_new database
-- it'll create the column for dise_slug on tb_electedrep_master table
-- and fill it up with slugs form dise
create extension pg_similarity;
alter table tb_electedrep_master add column dise_slug text;

-----------------------------------------------------
-------------       ASSEMBLY       ------------------
-----------------------------------------------------

-- fixes typo in "HUBLI-DHARWAD- WEST"
update tb_electedrep_master set const_ward_name=replace(const_ward_name, '- ', '-') where id=479;

-- set some slugs that can't be automatically detected
-- empty ones are the ones with no or more than one matches
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='BAINDUR';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='BELGAUM';  -- dise has bengaum dakshin, uttar, rural
update tb_electedrep_master set dise_slug='bijapur-city' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='BIJAPUR';
update tb_electedrep_master set dise_slug='chikkodi-sadalga' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='CHIKKODI';
update tb_electedrep_master set dise_slug='kundapura' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='COONDAPUR';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='DAVANGERE';  -- davangere north, south
update tb_electedrep_master set dise_slug='devadurga' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='DEODURG';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='HUBLI RURAL';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='HUVIN-HIPPARGI';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='KALMALA';
update tb_electedrep_master set dise_slug='kapu' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='KAUP';
update tb_electedrep_master set dise_slug='kr-pura' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='KR PURAM';
update tb_electedrep_master set dise_slug='sindhanur' where status='active' and const_ward_type='MLA Constituency' and const_ward_name='SINDHNOOR';
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='TUMKUR';  -- tumkur city, rural
update tb_electedrep_master set dise_slug=null where status='active' and const_ward_type='MLA Constituency' and const_ward_name='VARTHUR';


create materialized view mvw_dise_assembly as
select t.assembly_name, t.slug from
dblink('host=localhost dbname=klpdise_olap user=klp'::text,
    'select assembly_name, slug from dise_1415_assembly_aggregations'::text)
    t(assembly_name text, slug text);

-- select const_ward_type, const_ward_name, mvw_dise_assembly.assembly_name, mvw_dise_assembly.slug
-- from tb_electedrep_master
-- left outer join mvw_dise_assembly on (
--     jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.92
-- )
-- where const_ward_type='MLA Constituency' and status='active' and dise_slug is null
-- order by const_ward_name;

update tb_electedrep_master
set
    dise_slug=mvw_dise_assembly.slug
from mvw_dise_assembly
where jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.98 and
    lev(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.8 and
    const_ward_type='MLA Constituency' and
    status='active' and
    dise_slug is null;

update tb_electedrep_master
set
    dise_slug=mvw_dise_assembly.slug
from mvw_dise_assembly
where jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.85 and
    lev(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.8 and
    const_ward_type='MLA Constituency' and
    status='active' and
    dise_slug is null;

update tb_electedrep_master
set
    dise_slug=mvw_dise_assembly.slug
from mvw_dise_assembly
where jarowinkler(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.75 and
    lev(upper(const_ward_name), upper(mvw_dise_assembly.assembly_name)) > 0.75 and
    const_ward_type='MLA Constituency' and
    status='active' and
    dise_slug is null;

drop materialized view mvw_dise_assembly;

-----------------------------------------------------
------------       PARLIAMENT       -----------------
-----------------------------------------------------

update tb_electedrep_master set dise_slug='dakshina-kannada' where status='active' and const_ward_type='MP Constituency' and const_ward_name='DAKSHINA';
update tb_electedrep_master set dise_slug='udupi-chikmagalur' where status='active' and const_ward_type='MP Constituency' and const_ward_name='UDUPI';
update tb_electedrep_master set dise_slug='uttara-kannada' where status='active' and const_ward_type='MP Constituency' and const_ward_name='UTTARA';

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
where jarowinkler(upper(const_ward_name), upper(mvw_dise_parliament.parliament_name)) > 0.95 and
    const_ward_type='MP Constituency' and
    status='active' and
    dise_slug is null;

drop materialized view mvw_dise_parliament;