/* vi:si:et:sw=4:sts=4:ts=4 */

'use strict';
(function() {
    var preschoolString = 'PreSchool';
    var schoolString = 'Primary School';

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        loadQuestions('schoolString',[]);

    }

    
    function loadQuestions(schoolType, params) {
        //var params = klp.router.getHash().queryParams;
        /*var detailURL = "sys/version/school";
        var $detailXHR = klp.api.do(detailURL, params);
        startDetailLoading(schoolType);
        $detailXHR.done(function(data) {*/
            
        //});
        var questions = [
                            {'question':'Was the school open?','id':1 },
                            {'question':'Was the teacher present in each class?','id':2 },
                            {'question':'Does the school have an all weather (pucca) building?','id':3 },
                            {'question':'Are all the toilets in the school functional?','id':4 },
                            {'question':'Does the school have a separate functional toilet for girls?','id':5 },
                            {'question':'Does the school have drinking water?','id':6 },
                            {'question':'Is a Mid Day Meal served in the school?','id':7 },
                            {'question':'Is there a Boundary wall/ Fencing?','id':8 },
                            {'question':'Is there a Play ground?','id':9 },
                            {'question':'Is there Accessibility to students with disabilities?','id':10 },
                            {'question':'Is there a Separate office for Headmaster?','id':11 },
                            {'question':'Is there a Separate room as Kitchen / Store for Mid day meals?','id':12 },
                            {'question':'Is there a Library?','id':13 },
                            {'question':'Are there Play Materials or Sports Equipments?','id':14 },
                            {'question':'Is there a Designated Librarian/Teacher?','id':15 },
                            {'question':'Is there a Class-wise timetable for the Library?','id':16 },
                            {'question':'Is there Teaching and Learning material?','id':17 },
                            {'question':'Are there Sufficient number of class rooms?','id':18 },
                            {'question':'Were at least 5% of the children enrolled present on the day you visited the school?','id':19 }
                        ];
        var tplSysSchool = swig.compile($('#tpl-sysSchool').html());  
        var html =  '<form action="/submitSys"><table class="table-base table-list-view table-base-sys">' +
                    '<tbody><tr class="table-base-heading green-pista-bg">' +
                    '<th class="white">All Observations below are mandatory</th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '<th></th>' +
                    '</tr>';
        html = html + tplSysSchool({'questions':questions});
        html = html + '</tbody></table></form>';
        $('#sysq_school').html(html);
    }

})();