(function() {
    var tplAssessment;
    klp.init = function() {
        console.log("init programme page", PROGRAMME_ID);
        klp.router = new KLPRouter();
        klp.router.init();
        tplAssessment = swig.compile($('#tpl-assessment').html());
        fetchProgrammeDetails();
    };

    function fetchProgrammeDetails() {
        var schoolId = klp.router.getHash().queryParams.school;
        var $xhr = klp.api.do("programme/info/", {
            'programme_id': PROGRAMME_ID,
            'school_id': schoolId
        });
        $xhr.done(function(data) {
            renderAssessments(data.features);
        });
    }

    function renderAssessments(assessments) {
        $('#assessmentsContainer').empty();
        assessments.forEach(function(assessment, i) {
            var html = tplAssessment(assessment);
            $('#assessmentsContainer').append(html);
        });
    }

})();