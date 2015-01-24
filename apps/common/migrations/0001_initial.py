# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.RunSQL('drop view if exists vw_ang_display_master'),
        migrations.RunSQL('drop view if exists vw_anginfra_agg'),
        migrations.RunSQL('drop view if exists vw_boundary_coord'),
        migrations.RunSQL('drop view if exists vw_dise_display_master'),
        migrations.RunSQL('drop view if exists vw_dise_facility_agg'),
        migrations.RunSQL('drop view if exists vw_dise_info'),
        migrations.RunSQL('drop view if exists vw_dise_rte_agg'),
        migrations.RunSQL('drop view if exists vw_electedrep_master'),
        migrations.RunSQL('drop view if exists vw_inst_coord'),
        migrations.RunSQL('drop view if exists vw_lib_borrow'),
        migrations.RunSQL('drop view if exists vw_lib_lang_agg'),
        migrations.RunSQL('drop view if exists vw_lib_level_agg'),
        migrations.RunSQL('drop view if exists vw_libinfra'),
        migrations.RunSQL('drop view if exists vw_mdm_agg'),
        migrations.RunSQL('drop view if exists vw_paisa_data'),
        migrations.RunSQL('drop view if exists vw_school_electedrep'),
        migrations.RunSQL('drop view if exists vw_school_eval'),

        migrations.RunSQL('revoke all on tb_teacher from web'),
        migrations.RunSQL('revoke all on tb_teacher_class from web'),
        migrations.RunSQL('revoke all on tb_student_eval from web'),
        migrations.RunSQL('revoke all on tb_student_class from web'),
        migrations.RunSQL('revoke all on tb_student from web'),
        migrations.RunSQL('revoke all on tb_school_basic_assessment_info from web'),
        migrations.RunSQL('revoke all on tb_school_assessment_agg from web'),
        migrations.RunSQL('revoke all on tb_school_agg from web'),
        migrations.RunSQL('revoke all on tb_school from web'),
        migrations.RunSQL('revoke all on tb_question from web'),
        migrations.RunSQL('revoke all on tb_programme from web'),
        migrations.RunSQL('revoke all on tb_institution_basic_assessment_info_cohorts from web'),
        migrations.RunSQL('revoke all on tb_institution_basic_assessment_info from web'),
        migrations.RunSQL('revoke all on tb_institution_assessment_agg_cohorts from web'),
        migrations.RunSQL('revoke all on tb_institution_assessment_agg from web'),
        migrations.RunSQL('revoke all on tb_institution_agg from web'),
        migrations.RunSQL('revoke all on tb_class from web'),
        migrations.RunSQL('revoke all on tb_child from web'),
        migrations.RunSQL('revoke all on tb_boundary from web'),
        migrations.RunSQL('revoke all on tb_bhierarchy from web'),
        migrations.RunSQL('revoke all on tb_assessment from web'),
        migrations.RunSQL('revoke all on tb_address from web'),
        migrations.RunSQL('revoke all on tb_academic_year from web'),
    ]
