from django.core.management.base import BaseCommand
from django.conf import settings
from django.db import connection
from collections import defaultdict
import os
from datetime import datetime

from common.utils import Date
from schools.models import (
    School, Boundary)
from stories.models import (
    Question, Questiongroup, QuestionType, 
    QuestiongroupQuestions, Source, UserType,
    Story, Answer)

from rest_framework.exceptions import (
    APIException, PermissionDenied,
    ParseError, MethodNotAllowed,
    AuthenticationFailed
)
from django.db.models import Q, Count

from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4, cm
from reportlab.platypus import Paragraph, Table, TableStyle, Image
from reportlab.platypus.flowables import HRFlowable

from reportlab.lib.enums import TA_JUSTIFY, TA_LEFT, TA_CENTER
from reportlab.lib import colors
# from reportlab.platypus.doctemplate import SimpleDocTemplate
# from reportlab.platypus import Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
# from reportlab.lib.pagesizes import A4, cm
# from reportlab.platypus import Table, TableStyle
# from reportlab.lib import colors


class Command(BaseCommand):
    help = 'Generates a report on SMS data'

    def make_pdf(self, data, start_date, end_date, filename):

        width, height = A4
        styles = getSampleStyleSheet()
        styleN = styles["BodyText"]
        styleN.alignment = TA_LEFT
        styleN.fontName = 'Helvetica'
        styleBH = styles["Heading3"]
        styleBH.alignment = TA_CENTER
        styleBH.fontName = 'Helvetica'
        styleBH.textColor = colors.purple
        styleTH = styles["Heading1"]
        styleTH.alignment = TA_CENTER
        styleTH.fontName = 'Helvetica'
        styleTH.textColor = colors.green
        styleGH = styles["Heading2"]
        styleGH.alignment = TA_CENTER
        styleGH.fontName = 'Helvetica'
        styleGH.textColor = colors.black
        #styleGH.backColor = colors.lightgrey

        styleNC = styles["BodyText"]
        #styleNC.alignment = TA_CENTER
        styleNC.fontName = 'Helvetica'
   

        def coord(x, y, unit=1):
            x, y = x * unit, height -  y * unit
            return x, y

        # Headers
        #hdescrpcion = Paragraph('''<b>descrpcion</b>''', styleBH)
        
        # Texts
        #descrpcion = Paragraph('long paragraph', styleN)
        def style_row(row_array, style):
            styled_array = []
            for each in row_array:
                styled_array.extend([Paragraph(str(each),style)])
            return styled_array
       
            
        c = canvas.Canvas(os.path.join(settings.PDF_REPORTS_DIR, 'gka_sms/')+filename+".pdf", pagesize=A4)
        styled_data = [style_row(data[0],styleGH)]
        for row in data[1:4]:
            styled_data.append(style_row(row,styleN))

        table_header = Table(styled_data, colWidths=[7 * cm,
                                       5* cm, 5 * cm])
        table_header.setStyle(TableStyle([
                       ('INNERGRID', (0,0), (-1,-1), 0.25, colors.lightgrey),
                       ('BOX', (0,0), (-1,-1), 0.25, colors.lightgrey),
                       ('LINEBELOW', (0,0), (2, 0), 1.0, colors.green),
                       ('LINEBELOW', (0,3), (2, 3), 1.0, colors.green),
                       
                    ]))
        table_header.wrapOn(c, width, height)
        table_header.drawOn(c, *coord(1.8, 9, cm))
        
        styled_data =[style_row(['Questions','Yes','No','Yes','No'],styleBH)] 
        for row in data[4:len(data)]:
            styled_data.append(style_row(row,styleN))
        
        table = Table(styled_data, colWidths=[7 * cm,
                                       2.5 * cm, 2.5 * cm,
                                       2.5 * cm, 2.5 * cm])
        table.setStyle(TableStyle([
                       ('INNERGRID', (0,0), (-1,-1), 0.25, colors.lightgrey),
                       ('BOX', (0,0), (-1,-1), 0.25, colors.lightgrey),
                       #('LINEBELOW', (0,0), (2, 0), 1.0, colors.green),
                       
                    ]))
        table.wrapOn(c, width, height)
        table.drawOn(c, *coord(1.8, 15, cm))
        header = Paragraph('GKA SMS Summary<br/><hr/>', styleTH)
        header.wrapOn(c, width, height)
        header.drawOn(c, *coord(0, 4, cm))
        date_range = Paragraph("From " + start_date.strftime("%d %b, %Y") + " to " + end_date.strftime("%d %b, %Y"), styleBH)
        date_range.wrapOn(c, width, height)
        date_range.drawOn(c, *coord(0, 4.5, cm))
        hr = HRFlowable(width="80%", thickness=1, lineCap='round', color=colors.lightgrey, spaceBefore=1, spaceAfter=1, hAlign='CENTER', vAlign='BOTTOM', dash=None)
        hr.wrapOn(c, width, height)
        hr.drawOn(c, *coord(1.8, 3.2, cm))
        logo_image = Image("%s/images/akshara_logo.jpg" % settings.STATICFILES_DIRS) 
        logo_image.drawOn(c, *coord(14, 3, cm))
        c.save()

    def get_json(self, source, stories_qset):
        json = {}
        json['stories'] = stories_qset.count()
        json['schools'] = stories_qset.distinct('school').count()
        return json

    def transform_data(self, district):
        blocks =[]
        questions = {}
        for block in district["blocks"]:
            data = [["Details", "Block-"+block["name"].capitalize(), "District-"+district["name"].capitalize()]]
            data.append(["Schools", block["sms"]["schools"], district["sms"]["schools"]])
            data.append(["SMS Messages", block["sms"]["stories"], district["sms"]["stories"]])
            data.append(["Schools with SMS Messages", block["sms"]["schools_with_stories"], district["sms"]["schools_with_stories"]])

            for each in block["details"]:
                questions[each["question"]["display_text"]]= {"block": self.get_response_str(each["answers"])}
            for each in district["details"]:
                questions[each["question"]["display_text"]]["district"] = self.get_response_str(each["answers"])
            for question in questions:
                row = [question]
                row.extend(questions[question]["block"])
                row.extend(questions[question]["district"])
                data.append(row)
            blocks.append(data)
        return blocks      

    def get_response_str(self, answers):
        yes = 0
        no = 0
        if answers["options"]:
            if "Yes" in answers["options"]:
                yes = answers["options"]["Yes"]
            if "No" in answers["options"]:
                no = answers["options"]["No"]
            return  [str(yes)+'('+str((yes*100)/(yes+no))+'%)',str(no)+'('+str((no*100)/(yes+no))+'%)']
        else:
            return "No Responses"

    def source_filter(self, source, stories_qset):
        stories_qset = stories_qset.filter(
            group__source__name=source)

        return stories_qset
    
    def get_story_meta(self, boundary_id, boundary_type, start_date, end_date):
        source = 'sms'
        admin2_id = None
        admin1_id = None
        if boundary_type == 'block':
            admin2_id = boundary_id
        if boundary_type == 'district':
            admin1_id = boundary_id
        
        school_type = 'Primary School'

        school_qset = School.objects.filter(
            admin3__type__name=school_type, status=2)
        stories_qset = Story.objects.filter(
            school__admin3__type__name=school_type)

        if admin1_id:
            school_qset = school_qset.filter(
                schooldetails__admin1__id=admin1_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin1__id=admin1_id)

        if admin2_id:
            school_qset = school_qset.filter(
                schooldetails__admin2__id=admin2_id)
            stories_qset = stories_qset.filter(
                school__schooldetails__admin2__id=admin2_id)
        
        if start_date:
            stories_qset = stories_qset.filter(
                date_of_visit__gte=start_date)

        if end_date:
            stories_qset = stories_qset.filter(
                date_of_visit__lte=end_date)
        
        if source:
            stories_qset = self.source_filter(
                source,
                stories_qset
            )
        #print stories_qset.count()

        response_json = {}
        response_json['schools'] = school_qset.count()
        response_json['stories'] = stories_qset.count()
        response_json['schools_with_stories'] = stories_qset.distinct('school').count()

        #print response_json
        return response_json
    
    def get_que_and_ans(self, stories, source, school_type):
        response_list = []
        questions = Question.objects.filter(
            is_featured=True).select_related(
                'question_type', 'school_type'
            )

        if source:
            questions = questions.filter(
                questiongroup__source__name=source)

        if school_type:
            questions = questions.filter(
                school_type__name=school_type)

        #print questions.count()
        for question in questions.distinct('id'):
            j = {}
            j['question'] = {}
            j['question']['key'] = question.key
            j['question']['text'] = question.text
            j['question']['display_text'] = question.display_text
            j['answers'] = {}
            j['answers']['question_type'] = question.question_type.name

            answer_counts = question.answer_set.filter(
                story__in=stories
            ).values('text').annotate(answer_count=Count('text'))

            options = {}
            for count in answer_counts:
                options[count['text']] = count['answer_count']
            j['answers']['options'] = options
            response_list.append(j)

        return response_list


    def get_story_details(self, boundary_id, boundary_type, start_date, end_date):
        source = 'sms'
        admin1_id = None
        admin2_id = None
        school_type = 'Primary School'
        if boundary_type == 'block':
            admin2_id = boundary_id
        if boundary_type == 'district':
            admin1_id = boundary_id

        stories = Story.objects.all()

        if source:
            stories = stories.filter(group__source__name=source)

        if school_type:
            stories = stories.filter(school__admin3__type__name=school_type)

        if admin1_id:
            stories = stories.filter(
                school__schooldetails__admin1__id=admin1_id
            )

        if admin2_id:
            stories = stories.filter(
                school__schooldetails__admin2__id=admin2_id
            )

        if start_date:
            stories = stories.filter(date_of_visit__gte=start_date)

        if end_date:
            stories = stories.filter(date_of_visit__lte=end_date)
        response_json = self.get_que_and_ans(stories, source, school_type)
        return response_json


    def handle(self, *args, **options):
        #gka_district_ids = [424, 417, 416, 419, 418, 445]
        gka_district_ids = [ 418]
        
        #bellary, bidar, gulbarga, koppal, raichur, yadgiri
        
        start_date = args[0]
        end_date = args[1]
        date = Date()
        if start_date:
            sane = date.check_date_sanity(start_date)
            if not sane:
                raise APIException("Please enter `from` in the format YYYY-MM-DD")
            else:
                start_date = date.get_datetime(start_date)

        if end_date:
            sane = date.check_date_sanity(end_date)
            if not sane:
                raise APIException("Please enter `to` in the format YYYY-MM-DD")
            else:
                end_date = date.get_datetime(end_date)
        districts = []
        for district_id in gka_district_ids:
            
            district = Boundary.objects.get(id=district_id)
            admin1_json = { 'name': district.name, 'id': district.id}
            admin1_json['sms'] = self.get_story_meta(district.id,'district',start_date, end_date)
            admin1_json['details'] = self.get_story_details(district.id,'district',start_date, end_date)
            admin1_json['blocks'] = []
            #print admin1_json   
            blocks = (Boundary.objects.all_active().filter(
                parent_id=district_id, 
                type=district.type
            ).select_related('boundarycoord__coord', 'type__name',
                            'hierarchy__name'))
            for block in blocks:
                admin2_json = { 'name': block.name, 'id': block.id}
                admin2_json['sms'] = self.get_story_meta(block.id,'block', start_date, end_date)
                admin2_json['details'] = self.get_story_details(block.id,'block', start_date, end_date)    
                admin1_json['blocks'].append(admin2_json)
            districts.append(admin1_json)

        for each in districts:
            blks = self.transform_data(each)
            for blk in blks: 
                self.make_pdf(blk,start_date,end_date,blk[0][1])
                

        # self.check_data_files()

        # count = 0
        # with open(self.file_path, 'r') as statusidfile:
        #     reader = DictReader(statusidfile)
        #     for ems_school in reader:
        #         try:
        #             school = School.objects.get(id=ems_school['id'])

        #             if school.status == int(ems_school['active']):
        #                 continue

        #             log('Found school with different status: ' + str(school.id))
        #             school.status = ems_school['active']
        #             school.save()
        #             count += 1
        #         except Exception, e:
        #             log('Could not find school: ' + str(school.id))

