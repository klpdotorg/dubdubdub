import time

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


class QuestiongroupSerializer(KLPSerializer):

    source = serializers.CharField(source='source.name')
    start_date = serializers.SerializerMethodField('get_start_date')
    end_date = serializers.SerializerMethodField('get_end_date')
    survey = SurveySerializer()
    created_by = UserBasicSerializer()
    school_type = BoundaryTypeSerializer()
    created_at = serializers.SerializerMethodField('get_created_at')
    updated_at = serializers.SerializerMethodField('get_updated_at')

    class Meta:
        model = Questiongroup
        fields = (
            'id', 'status', 'version', 'source',
            'start_date', 'end_date', 'survey',
            'name', 'created_by', 'school_type',
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


class QuestionSerializer(KLPSerializer):
    question_type = serializers.CharField(source='question_type.name')
    options = serializers.SerializerMethodField('get_options')
    school_type = BoundaryTypeSerializer()
    questiongroup_set = QuestiongroupSerializer(read_only=True, many=True)

    class Meta:
        model = Question
        fields = (
            'id', 'question_type', 'text', 'qid',
            'options', 'display_text', 'key', 'school_type',
            'questiongroup_set',
        )

    def get_options(self, obj):
        return obj.options.replace('{', '').replace('}', '').split(',') if obj.options else None


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
