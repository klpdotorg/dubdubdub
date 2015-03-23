(function() {
    klp = klp || {};

    klp.init = function() {
        console.log("initting app");
        fetchData();
    };

    function fetchData() {
        //TODO: collect all form params
        var params = {
            'source': 'ivrs',
            'school_type': 'Primary School'
        };
        var url = "stories/meta";
        var $xhr = klp.api.do(url, params);
        $xhr.done(function(data) {
            //TODO: Render data from back-end onto template
            renderData(data);

        });
    }

    function renderData(data) {
        var questions = data.questions;
        $('#num_response_this_week_n').text(data.total_responses);
        for (var i=0; i<questions.length; i++) {
            var question = questions[i];
            renderQuestionChart(question, i);
        }
    }

    function renderQuestionChart(questionData, number) {
        var questionType = questionData.question_type;
        var question = questionData.question;
        var answers = questionData.answers;
        var order = number + 1;
        var $container = $('#question' + order);

    }
})();