import time
from datetime import datetime

from django.utils.translation import ugettext as _, activate as activate_language
from common.serializers import KLPSerializer, KLPSimpleGeoSerializer
from rest_framework import serializers
from schools.models import (School, Boundary, DiseInfo, ElectedrepMaster,
    BoundaryType, Assembly, Parliament, Partner, Postal, PaisaData, MdmAgg)
from schools.serializers import PartnerSerializer, BoundaryTypeSerializer
from users.serializers import UserBasicSerializer
from .models import (
    Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Story, Answer,
    StoryImage, Survey, Source
)


class SurveySerializer(KLPSerializer):

    partner = PartnerSerializer(read_only=True)
    partner_id = serializers.PrimaryKeyRelatedField(
        write_only=True,
        source='partner'
        )

    class Meta:
        model = Survey
        fields = (
            'id', 'name', 'partner', 'partner_id'
        )


class TimestampField(serializers.DateTimeField):
    def to_native(self, value):
        if value:
            return int(time.mktime(value.timetuple()))
        else:
            return value

    def from_native(self, value):
        try:
            return datetime.strptime(value,'%Y-%m-%dT%H:%M:%S')
        except:
            raise serializers.ValidationError(
                'Date format should be: YYYY-MM-DDTHH:MM:SS'
            )


class QuestiongroupSerializer(KLPSerializer):

    source = serializers.CharField(
        read_only=True,
        source='source.name'
    )
    source_id = serializers.PrimaryKeyRelatedField(
        write_only=True,
        source='source'
    )

    end_date = TimestampField(source='end_date')
    start_date = TimestampField(source='start_date')
    created_at = TimestampField(source='created_at')
    updated_at = TimestampField(source='updated_at')

    survey = SurveySerializer(read_only=True)
    survey_id = serializers.PrimaryKeyRelatedField(
        write_only=True,
        source='survey'
    )

    created_by = UserBasicSerializer(read_only=True)
    created_by_id = serializers.PrimaryKeyRelatedField(
        required=False,
        write_only=True,
        source='created_by'
    )

    school_type = BoundaryTypeSerializer(read_only=True)
    school_type_id = serializers.PrimaryKeyRelatedField(
        required=False,
        write_only=True,
        source='school_type'
    )

    class Meta:
        model = Questiongroup
        fields = (
            'id', 'status', 'version', 'source',
            'source_id', 'start_date', 'end_date',
            'survey', 'survey_id', 'name',
            'created_by', 'created_by_id',
            'school_type', 'school_type_id',
            'created_at', 'updated_at'
        )

    def get_created_at(self, obj):
        return self.make_epoch(obj.created_at)

    def get_updated_at(self, obj):
        return self.make_epoch(obj.updated_at)

    def get_start_date(self, obj):
        return self.make_epoch(obj.start_date)

    def get_end_date(self, obj):
        return self.make_epoch(obj.end_date)

    def make_epoch(self, date):
        if date:
            return int(time.mktime(date.timetuple()))
        else:
            return date


class QuestiongroupQuestionsSerializer(KLPSerializer):
    through_id = serializers.Field('id')
    sequence = serializers.Field('sequence')
    status = serializers.Field('questiongroup.status')
    questiongroup = serializers.Field('questiongroup.id')
    source = serializers.Field('questiongroup.source.name')

    class Meta:
        model = QuestiongroupQuestions
        fields = (
            'through_id', 'sequence', 'status', 'questiongroup', 'source'
        )


class QuestionSerializer(KLPSerializer):

    question_type = serializers.CharField(source='question_type.name')
    options = serializers.SerializerMethodField('get_options')
    text_kn = serializers.SerializerMethodField('get_text_kn')
    school_type = BoundaryTypeSerializer()
    questiongroup_set = QuestiongroupQuestionsSerializer(
        source='questiongroupquestions_set',
        read_only=True,
        many=True
    )

    class Meta:
        model = Question
        fields = (
            'id', 'question_type', 'text', 'text_kn', 'qid',
            'options', 'display_text', 'key', 'school_type',
            'questiongroup_set',
        )

    def get_options(self, obj):
        return obj.options.replace('{', '').replace('}', '').split(',') if obj.options else None

    def get_text_kn(self, obj):
        activate_language("kn")
        return _(obj.text)


class SourceSerializer(KLPSerializer):
    class Meta:
        model = Source


class SchoolQuestionsSerializer(KLPSerializer):
    questions = QuestionSerializer(many=True, source='get_questions')

    class Meta:
        model = School
        fields = ('id', 'name', 'questions')


class AnswerSerializer(KLPSerializer):
    question = QuestionSerializer(source='question')

    class Meta:
        model = Answer
        field = ('question', 'text')


class StoryImageSerializer(KLPSerializer):
    image_url = serializers.CharField(source='image.url')

    class Meta:
        model = StoryImage
        fields = ('image_url', 'is_verified')


class StorySerializer(KLPSerializer):
    date = serializers.CharField(source='date_of_visit')
    images = StoryImageSerializer(many=True, source='storyimage_set')
    school_name = serializers.CharField(source='school.name')
    school_url = serializers.CharField(source='school.get_absolute_url')

    class Meta:
        model = Story
        fields = (
            'id', 'name', 'date', 'date_of_visit', 'school',
            'school_name', 'school_url', 'comments', 'is_verified',
            'images', 'created_at')


class StoryWithAnswersSerializer(KLPSerializer):
    date = serializers.CharField(source='date_of_visit')
    images = StoryImageSerializer(many=True, source='storyimage_set')
    answers = AnswerSerializer(many=True, source='answer_set')

    class Meta:
        model = Story
        fields = (
            'id', 'name', 'date', 'date_of_visit', 'school', 'comments',
            'is_verified', 'images', 'answers', 'created_at')

    def get_answers(self, obj):
        return obj.answer_set.all()
