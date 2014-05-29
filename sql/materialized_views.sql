# list of cluster ids with block and districts
# Only for primary schools
create materialized view mvw_boundary_primary
as select tb1.id as cluster_id,
tb2.id as block_id,
tb3.id as district_id
from tb_boundary tb1, tb_boundary tb2, tb_boundary tb3
where tb1.hid=11 and tb1.type=1
and tb2.hid=10 and tb2.type=1
and tb1.parent=tb2.id
and tb3.hid=9 and tb3.type=1
and tb2.parent=tb3.id;

# details about the school(both primary and preschools)
# putting the locations in a view to save query time
create materialized view mvw_school_details as
select tbs.id as id,
tb1.id as cluster_or_circle_id,
tb2.id as block_or_project_id,
tb3.id as district_id,
tb1.type as type
from tb_school tbs, tb_boundary tb1, tb_boundary tb2, tb_boundary tb3
where tbs.bid=tb1.id
and tb1.parent=tb2.id
and tb2.parent=tb3.id;