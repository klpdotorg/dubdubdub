# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.contrib.gis.db.models.fields


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='AcademicYear',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=20, blank=True)),
            ],
            options={
                'db_table': 'tb_academic_year',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Address',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('address', models.CharField(max_length=1000, blank=True)),
                ('area', models.CharField(max_length=1000, blank=True)),
                ('pincode', models.CharField(max_length=20, blank=True)),
                ('landmark', models.CharField(max_length=1000, blank=True)),
                ('instidentification', models.CharField(max_length=1000, blank=True)),
                ('bus', models.CharField(max_length=1000, blank=True)),
                ('instidentification2', models.CharField(max_length=1000, blank=True)),
            ],
            options={
                'db_table': 'tb_address',
                'managed': False,
                'verbose_name_plural': 'Addresses',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='AnganwadiDisplayMaster',
            fields=[
                ('key', models.CharField(max_length=36, serialize=False, primary_key=True)),
                ('value', models.CharField(max_length=200, blank=True)),
            ],
            options={
                'db_table': 'mvw_ang_display_master',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='AngDisplayMaster',
            fields=[
                ('key', models.CharField(max_length=30, serialize=False, primary_key=True)),
                ('value', models.CharField(max_length=200)),
            ],
            options={
                'db_table': 'mvw_ang_display_master',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Assembly',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True, db_column='ac_id')),
                ('gid', models.IntegerField()),
                ('number', models.IntegerField(db_column='ac_no')),
                ('name', models.CharField(max_length=35, db_column='ac_name')),
                ('state_ut', models.CharField(max_length=35)),
                ('coord', django.contrib.gis.db.models.fields.GeometryField(srid=4326, db_column='the_geom')),
            ],
            options={
                'db_table': 'mvw_assembly',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Assessment',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300)),
                ('start', models.DateField(null=True, blank=True)),
                ('end', models.DateField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_assessment',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Boundary',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=300)),
            ],
            options={
                'db_table': 'tb_boundary',
                'managed': False,
                'verbose_name_plural': 'Boundaries',
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryCoord',
            fields=[
                ('boundary', models.OneToOneField(primary_key=True, db_column='id_bndry', serialize=False, to='schools.Boundary')),
                ('typ', models.CharField(max_length=20, db_column='type')),
                ('coord', django.contrib.gis.db.models.fields.GeometryField(srid=4326)),
            ],
            options={
                'db_table': 'mvw_boundary_coord',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryHierarchy',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300)),
            ],
            options={
                'db_table': 'tb_bhierarchy',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryPrimarySchool',
            fields=[
                ('cluster', models.ForeignKey(related_name='boundary_ps_cluster', primary_key=True, db_column='cluster_id', serialize=False, to='schools.Boundary')),
            ],
            options={
                'db_table': 'mvw_boundary_primary',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='BoundaryType',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=300)),
            ],
            options={
                'db_table': 'tb_boundary_type',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Child',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300, blank=True)),
                ('dob', models.DateField(null=True, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
            ],
            options={
                'db_table': 'tb_child',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DiseDisplayMaster',
            fields=[
                ('key', models.CharField(max_length=36, serialize=False, primary_key=True)),
                ('value', models.CharField(max_length=200, blank=True)),
            ],
            options={
                'db_table': 'mvw_dise_display_master',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DiseInfo',
            fields=[
                ('dise_code', models.CharField(max_length=32, serialize=False, primary_key=True)),
                ('classroom_count', models.IntegerField(null=True, blank=True)),
                ('teacher_count', models.IntegerField(null=True, blank=True)),
                ('boys_count', models.IntegerField(null=True, blank=True)),
                ('girls_count', models.IntegerField(null=True, blank=True)),
                ('lowest_class', models.IntegerField(null=True, blank=True)),
                ('highest_class', models.IntegerField(null=True, blank=True)),
                ('acyear', models.CharField(max_length=15, blank=True)),
                ('sg_recd', models.IntegerField(null=True, blank=True)),
                ('sg_expnd', models.IntegerField(null=True, blank=True)),
                ('tlm_recd', models.IntegerField(null=True, blank=True)),
                ('tlm_expnd', models.IntegerField(null=True, blank=True)),
                ('ffs_recd', models.IntegerField(null=True, blank=True)),
                ('ffs_expnd', models.IntegerField(null=True, blank=True)),
                ('books_in_library', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'mvw_dise_info_olap',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DiseFacilityAgg',
            fields=[
                ('dise_info', models.ForeignKey(primary_key=True, db_column='dise_code', serialize=False, to='schools.DiseInfo')),
                ('score', models.DecimalField(null=True, max_digits=5, decimal_places=0, blank=True)),
                ('df_group', models.CharField(max_length=30, blank=True)),
            ],
            options={
                'db_table': 'mvw_dise_facility_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='DiseRteAgg',
            fields=[
                ('dise_info', models.ForeignKey(primary_key=True, db_column='dise_code', serialize=False, to='schools.DiseInfo')),
                ('status', models.CharField(max_length=30, blank=True)),
                ('rte_group', models.CharField(max_length=32, blank=True)),
            ],
            options={
                'db_table': 'mvw_dise_rte_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='ElectedrepMaster',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('elec_comm_code', models.IntegerField(null=True, blank=True)),
                ('const_ward_name', models.CharField(max_length=300, blank=True)),
                ('const_ward_type', models.TextField(blank=True)),
                ('neighbours', models.CharField(max_length=100, blank=True)),
                ('current_elected_rep', models.CharField(max_length=300, blank=True)),
                ('current_elected_party', models.CharField(max_length=300, blank=True)),
            ],
            options={
                'db_table': 'mvw_electedrep_master',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PaisaData',
            fields=[
                ('grant_type', models.CharField(max_length=32, serialize=False, primary_key=True)),
                ('grant_amount', models.IntegerField(null=True, blank=True)),
                ('criteria', models.CharField(max_length=32, blank=True)),
                ('operator', models.CharField(max_length=3, blank=True)),
                ('factor', models.CharField(max_length=32, blank=True)),
            ],
            options={
                'db_table': 'mvw_paisa_data',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Parliament',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True, db_column='pc_id')),
                ('gid', models.IntegerField()),
                ('number', models.IntegerField(db_column='pc_no')),
                ('name', models.CharField(max_length=35, db_column='pc_name')),
                ('state_ut', models.CharField(max_length=35)),
                ('coord', django.contrib.gis.db.models.fields.GeometryField(srid=4326, db_column='the_geom')),
            ],
            options={
                'db_table': 'mvw_parliament',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Partner',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300)),
                ('status', models.IntegerField()),
                ('info', models.CharField(max_length=500, blank=True)),
            ],
            options={
                'db_table': 'tb_partner',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Postal',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True, db_column='pin_id')),
                ('gid', models.IntegerField()),
                ('pincode', models.CharField(max_length=35)),
                ('coord', django.contrib.gis.db.models.fields.GeometryField(srid=4326, db_column='the_geom')),
            ],
            options={
                'db_table': 'mvw_postal',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Programme',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300)),
                ('start', models.DateField(null=True, blank=True)),
                ('end', models.DateField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_programme',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Question',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('desc', models.CharField(max_length=100)),
                ('qtype', models.IntegerField(null=True, blank=True)),
                ('maxmarks', models.DecimalField(null=True, max_digits=65535, decimal_places=65535, blank=True)),
                ('minmarks', models.DecimalField(null=True, max_digits=65535, decimal_places=65535, blank=True)),
                ('grade', models.CharField(max_length=100, blank=True)),
            ],
            options={
                'db_table': 'tb_question',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='School',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('name', models.CharField(max_length=300)),
                ('cat', models.CharField(max_length=128, choices=[('Model Primary', 'Model Primary'), ('Anganwadi', 'Anganwadi'), ('Lower Primary', 'Lower Primary'), ('Secondary', 'Secondary'), ('Akshara Balwadi', 'Akshara Balwadi'), ('Independent Balwadi', 'Independent Balwadi'), ('Upper Primary', 'Upper Primary')])),
                ('sex', models.CharField(max_length=128, choices=[('boys', 'Boys'), ('girls', 'Girls'), ('co-ed', 'Co-education')])),
                ('moi', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('mgmt', models.CharField(max_length=128, choices=[('p-a', 'Private Aided'), ('ed', 'Department of Education'), ('p-ua', 'Private Unaided')])),
                ('status', models.IntegerField()),
            ],
            options={
                'db_table': 'tb_school',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PreschoolBasicAssessmentInfo',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('agegroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_preschool_basic_assessment_info',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='PreschoolAssessmentAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('agegroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('aggtext', models.CharField(max_length=100)),
                ('aggval', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'db_table': 'tb_preschool_assessment_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='MdmAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='klpid', serialize=False, to='schools.School')),
                ('mon', models.CharField(max_length=15, blank=True)),
                ('wk', models.IntegerField(null=True, blank=True)),
                ('indent', models.IntegerField(null=True, blank=True)),
                ('attend', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'mvw_mdm_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='LibLevelAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='klp_school_id', serialize=False, to='schools.School')),
                ('class_name', models.IntegerField(null=True, db_column='class', blank=True)),
                ('month', models.CharField(max_length=10, blank=True)),
                ('year', models.CharField(max_length=10, blank=True)),
                ('book_level', models.CharField(max_length=50, blank=True)),
                ('child_count', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'mvw_lib_level_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='LibLangAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='klp_school_id', serialize=False, to='schools.School')),
                ('class_name', models.IntegerField(null=True, db_column='class', blank=True)),
                ('month', models.CharField(max_length=10, blank=True)),
                ('year', models.CharField(max_length=10, blank=True)),
                ('book_lang', models.CharField(max_length=50, blank=True)),
                ('child_count', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'mvw_lib_lang_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Libinfra',
            fields=[
                ('school', models.OneToOneField(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('libstatus', models.CharField(max_length=300, blank=True)),
                ('handoveryear', models.IntegerField(null=True, blank=True)),
                ('libtype', models.CharField(max_length=300, blank=True)),
                ('numbooks', models.IntegerField(null=True, blank=True)),
                ('numracks', models.IntegerField(null=True, blank=True)),
                ('numtables', models.IntegerField(null=True, blank=True)),
                ('numchairs', models.IntegerField(null=True, blank=True)),
                ('numcomputers', models.IntegerField(null=True, blank=True)),
                ('numups', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'mvw_libinfra',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='LibBorrow',
            fields=[
                ('trans_year', models.CharField(max_length=30, blank=True)),
                ('class_name', models.DecimalField(null=True, decimal_places=0, max_digits=3, db_column='class', blank=True)),
                ('issue_date', models.CharField(max_length=20, blank=True)),
                ('school', models.ForeignKey(primary_key=True, db_column='klp_school_id', serialize=False, to='schools.School')),
                ('school_name', models.CharField(max_length=50, blank=True)),
            ],
            options={
                'db_table': 'mvw_lib_borrow',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionBasicAssessmentInfoCohorts',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('cohortsnum', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'verbose_name': 'InstBasicAssInfoCohorts',
                'db_table': 'tb_institution_basic_assessment_info_cohorts',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionBasicAssessmentInfo',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'verbose_name': 'InstBasicAssInfo',
                'db_table': 'tb_institution_basic_assessment_info',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentSinglescoreMt',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('asstext', models.CharField(max_length=50)),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('order', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssSingleScoreMt',
                'db_table': 'tb_institution_assessment_singlescore_mt',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentSinglescoreGender',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('asstext', models.CharField(max_length=50)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('order', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssSingleScoreGender',
                'db_table': 'tb_institution_assessment_singlescore_gender',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentSinglescore',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('asstext', models.CharField(max_length=50)),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
                ('order', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssSingleScore',
                'db_table': 'tb_institution_assessment_singlescore',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentReadingAggCohorts',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('domain', models.CharField(max_length=100, blank=True)),
                ('domain_order', models.IntegerField(null=True, blank=True)),
                ('aggtext', models.CharField(max_length=100)),
                ('aggtext_order', models.IntegerField()),
                ('cohortsval', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssReadingAggCohorts',
                'db_table': 'tb_institution_assessment_reading_agg_cohorts',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentMtSinglescore',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssMtSingleScore',
                'db_table': 'tb_institution_assessment_mt_singlescore',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentGenderSinglescore',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('singlescore', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssGenderSingleScore',
                'db_table': 'tb_institution_assessment_gender_singlescore',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentAggCohorts',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('domain', models.CharField(max_length=100, blank=True)),
                ('domain_order', models.IntegerField(null=True, blank=True)),
                ('aggtext', models.CharField(max_length=100)),
                ('aggtext_order', models.IntegerField()),
                ('cohortsval', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'verbose_name': 'InstAssAggCohorts',
                'db_table': 'tb_institution_assessment_agg_cohorts',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAssessmentAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('studentgroup', models.CharField(max_length=50, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('domain', models.CharField(max_length=100, blank=True)),
                ('domain_order', models.IntegerField(null=True, blank=True)),
                ('aggtext', models.CharField(max_length=100)),
                ('aggtext_order', models.IntegerField()),
                ('aggval', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'db_table': 'tb_institution_assessment_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstitutionAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='id', serialize=False, to='schools.School')),
                ('name', models.CharField(max_length=300, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_institution_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='InstCoord',
            fields=[
                ('school', models.OneToOneField(primary_key=True, db_column='instid', serialize=False, to='schools.School')),
                ('coord', django.contrib.gis.db.models.fields.GeometryField(srid=4326)),
            ],
            options={
                'db_table': 'mvw_inst_coord',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='AngInfraAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('ai_metric', models.CharField(max_length=30)),
                ('perc', models.IntegerField()),
                ('ai_group', models.CharField(max_length=30)),
            ],
            options={
                'db_table': 'mvw_anginfra_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='AnganwadiInfraAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('perc_score', models.DecimalField(null=True, max_digits=5, decimal_places=0, blank=True)),
                ('ai_group', models.CharField(max_length=30, blank=True)),
            ],
            options={
                'db_table': 'mvw_ang_infra_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='id', serialize=False, to='schools.School')),
                ('name', models.CharField(max_length=300, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_school_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolAssessmentAgg',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('aggtext', models.CharField(max_length=100)),
                ('aggval', models.DecimalField(null=True, max_digits=6, decimal_places=2, blank=True)),
            ],
            options={
                'db_table': 'tb_school_assessment_agg',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolBasicAssessmentInfo',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='sid', serialize=False, to='schools.School')),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('num', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_school_basic_assessment_info',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolClassTotalYear',
            fields=[
                ('school', models.ForeignKey(primary_key=True, db_column='schid', serialize=False, to='schools.School')),
                ('clas', models.IntegerField(db_column='clas')),
                ('total', models.IntegerField(db_column='total')),
            ],
            options={
                'db_table': 'mvw_school_class_total_year',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolDetails',
            fields=[
                ('school', models.OneToOneField(primary_key=True, db_column='id', serialize=False, to='schools.School')),
                ('num_boys', models.IntegerField(null=True, db_column='num_boys', blank=True)),
                ('num_girls', models.IntegerField(null=True, db_column='num_girls', blank=True)),
            ],
            options={
                'db_table': 'mvw_school_details',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolElectedrep',
            fields=[
                ('school', models.OneToOneField(related_name='electedrep', primary_key=True, db_column='sid', serialize=False, to='schools.School')),
            ],
            options={
                'db_table': 'mvw_school_electedrep',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='SchoolEval',
            fields=[
                ('school', models.IntegerField(serialize=False, primary_key=True, db_column='sid')),
                ('domain', models.CharField(max_length=100, blank=True)),
                ('value', models.CharField(max_length=50, blank=True)),
            ],
            options={
                'db_table': 'mvw_school_eval',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Student',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('otherstudentid', models.CharField(max_length=100, blank=True)),
                ('status', models.IntegerField()),
            ],
            options={
                'db_table': 'tb_student',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='StudentEval',
            fields=[
                ('question', models.ForeignKey(primary_key=True, db_column='qid', serialize=False, to='schools.Question')),
                ('mark', models.DecimalField(null=True, max_digits=5, decimal_places=2, blank=True)),
                ('grade', models.CharField(max_length=30, blank=True)),
            ],
            options={
                'db_table': 'tb_student_eval',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='StudentGroup',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=50)),
                ('section', models.CharField(max_length=1, blank=True)),
            ],
            options={
                'db_table': 'tb_class',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='StudentStudentGroup',
            fields=[
                ('student', models.ForeignKey(primary_key=True, db_column='stuid', serialize=False, to='schools.Student')),
                ('status', models.IntegerField()),
            ],
            options={
                'db_table': 'tb_student_class',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Teacher',
            fields=[
                ('id', models.IntegerField(serialize=False, primary_key=True)),
                ('name', models.CharField(max_length=300, blank=True)),
                ('sex', models.CharField(max_length=128, choices=[('male', 'Male'), ('female', 'Female')])),
                ('status', models.IntegerField(null=True, blank=True)),
                ('mt', models.CharField(max_length=128, choices=[('bengali', 'Bengali'), ('english', 'English'), ('gujarathi', 'Gujarathi'), ('hindi', 'Hindi'), ('kannada', 'Kannada'), ('konkani', 'Konkani'), ('malayalam', 'Malayalam'), ('marathi', 'Marathi'), ('nepali', 'Nepali'), ('oriya', 'Oriya'), ('sanskrit', 'Sanskrit'), ('sindhi', 'Sindhi'), ('tamil', 'Tamil'), ('telugu', 'Telugu'), ('urdu', 'Urdu'), ('multi lng', 'Multi Lingual'), ('other', 'Other'), ('not known', 'Not known')])),
                ('dateofjoining', models.DateField(null=True, blank=True)),
                ('type', models.CharField(max_length=50, blank=True)),
            ],
            options={
                'db_table': 'tb_teacher',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='TeacherQualification',
            fields=[
                ('teacher', models.ForeignKey(primary_key=True, db_column='tid', serialize=False, to='schools.Teacher')),
                ('qualification', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'tb_teacher_qual',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='TeacherStudentGroup',
            fields=[
                ('teacher', models.ForeignKey(primary_key=True, db_column='teacherid', serialize=False, to='schools.Teacher')),
                ('status', models.IntegerField(null=True, blank=True)),
            ],
            options={
                'db_table': 'tb_teacher_class',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
