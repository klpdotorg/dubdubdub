(function() {
    var tplAssessment;
    klp.init = function() {
        console.log("init programme page", PROGRAMME_ID);
        klp.router = new KLPRouter();
        klp.router.init();
        tplAssessmentClass = swig.compile($('#tpl-assessment-class').html());
        fetchProgrammeDetails();
    };

    function fetchProgrammeDetails() {
        var schoolId = klp.router.getHash().queryParams.school;
        var url = "programme/" + PROGRAMME_ID;
        var $xhr = klp.api.do(url, {
            'school': schoolId
        });
        $xhr.done(function(data) {
            var assessmentsContext = getContext(data);
            console.log("ass context", assessmentsContext);
            renderAssessments(assessmentsContext);
        });
    }

    function renderAssessments(assessmentClasses) {
        $('#assessmentsContainer').empty();
        var classes = _.keys(assessmentClasses);
        classes.forEach(function(className, i) {
            var html = tplAssessmentClass({
                'className': className,
                'assessments': assessmentClasses[className]
            });
            $('#assessmentsContainer').append(html);
        });
    }

    function getContext(data) {
        var assessmentsArray = data.features;
        var groupedByClass = _.groupBy(assessmentsArray, function(assessment) {
            return assessment.studentgroup;
        });
        _.each(_(groupedByClass).keys(), function(className) {
            groupedByClass[className] = getClassContext(groupedByClass[className]);
        });
        return groupedByClass;
        //console.log("group by", groupedByClass);
    }

    function getClassContext(classData) {
        var ret = [];
        _.each(classData, function(assessmentData) {
            ret.push(getAssessmentContext(assessmentData));
        });
        return ret;
    }

    function getAssessmentContext(assessmentData) {
        var genders = [];
        for (var j=0, length=assessmentData.singlescoredetails.gender.length; j < length; j++) {
            var scoreDetails = assessmentData.singlescoredetails.gender[j];
            var cohortsDetails = assessmentData.cohortsdetails.gender[j];
            var gender = {
                'name': scoreDetails.sex == 'male' ? 'Boys' : 'Girls',
                'singlescore': scoreDetails.singlescore,
                'cohorts': cohortsDetails.total
            };
            genders.push(gender);
        }
        assessmentData.genders = genders;

        var mts = [];
        for (var i=0, length = assessmentData.cohortsdetails.mt.length; i < length; i++) {
            var mt = {
                'name': assessmentData.cohortsdetails.mt[i].mt,
                'singlescore': assessmentData.singlescoredetails.mt[i].singlescore
            };
            mts.push(mt);
        }
        assessmentData.mts = mts;

        var compares = [];
        var boundary = assessmentData.singlescoredetails.boundary;
        var boundaryKeys = _.keys(boundary);
        _.each(boundaryKeys, function(key) {

            var compareObj = {
                'type': key,
                'name': boundary[key].boundary__name,
                'singlescore': boundary[key].singlescore
            };
            compares.push(compareObj);
        });
        assessmentData.compares = compares;

        return assessmentData;
    }

})();