from common.serializers import KLPSerializer, KLPSimpleGeoSerializer
from rest_framework import serializers
from schools.models import (School, Boundary, DiseInfo, ElectedrepMaster,
    BoundaryType, Assembly, Parliament, Postal, PaisaData, MdmAgg)
from .models import (Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Story, Answer, StoryImage)


class QuestionSerializer(KLPSerializer):
    question_type = serializers.CharField(source='question_type.name')
    options = serializers.SerializerMethodField('get_options')

    class Meta:
        model = Question
        fields = ('question_type', 'text', 'qid', 'options')

    def get_options(self, obj):
        return obj.options.replace('{', '').replace('}', '').split(',') if obj.options else None


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
    date = serializers.SerializerMethodField('get_date_string')
    images = StoryImageSerializer(many=True, source='storyimage_set')
    school_name = serializers.CharField(source='school.name')
    school_url = serializers.CharField(source='school.get_absolute_url')

    class Meta:
        model = Story
        fields = ('id', 'name', 'date', 'school', 'school_name', 'school_url', 'comments', 'is_verified', 'images')

    def get_date_string(self, obj):
        return obj.entered_timestamp.strftime('%Y-%m-%d') if obj.entered_timestamp else ''


class StoryWithAnswersSerializer(KLPSerializer):
    date = serializers.SerializerMethodField('get_date_string')
    images = StoryImageSerializer(many=True, source='storyimage_set')
    answers = AnswerSerializer(many=True, source='answer_set')

    class Meta:
        model = Story
        fields = ('id', 'name', 'date', 'school', 'comments', 'is_verified', 'images', 'answers')

    def get_date_string(self, obj):
        return obj.entered_timestamp.strftime('%Y-%m-%d') if obj.entered_timestamp else ''

    def get_answers(self, obj):
        return obj.answer_set.all()
