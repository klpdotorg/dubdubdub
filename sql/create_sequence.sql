create sequence boundary_id_seq;
alter table tb_boundary alter id set default nextval('boundary_id_seq');
Select setval('boundary_id_seq', max(id)) from tb_boundary;
ALTER SEQUENCE boundary_id_seq OWNED BY tb_boundary.id;

create sequence address_id_seq;
alter table tb_boundary alter id set default nextval('address_id_seq');
Select setval('address_id_seq', max(id)) from tb_address;
ALTER SEQUENCE address_id_seq OWNED BY tb_address.id;
