from common.serializers import KLPSerializer, KLPSimpleGeoSerializer
from rest_framework import serializers
from schools.models import (School, Boundary, DiseInfo, ElectedrepMaster,
    BoundaryType, Assembly, Parliament, Postal, PaisaData, MdmAgg)
from .models import (Question, Questiongroup, QuestionType,
    QuestiongroupQuestions, Story, Answer, StoryImage)


class QuestiongroupSerializer(KLPSerializer):

    source = serializers.CharField(source='source.name')

    class Meta:
        model = Questiongroup
        fields = (
            'version', 'source', 'start_date', 'end_date', 'name'
        )


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
