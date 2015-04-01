'use strict';
(function() {
  klp.init = function() {

    klp.router = new KLPRouter();
    klp.router.init();
    loadData();
    //get JS query params from URL

  }

  function loadData() {
    var params = klp.router.getHash().queryParams;
    var apiURL = ""; //FIXME: enter API url
    var $xhr = klp.api.do(apiURL, params);

    //TODO: do some loading behaviour
    $xhr.done(function(data) {
      renderPage(data);
    });
  }

  function renderPage(data) {
    // Chartist charts get rendered here 
    var data_respondent = {
      labels: ['Parents', 'Teachers', 'Community', 'Staff', 'Volunteers', 'Others'],
      series: [[80,200,100,80,200,100]]
    };

    renderBarChart('#chart_respondent',data_respondent);
    var data_ivrs = {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      series: [[500, 1200, 1000, 700, 540, 1030, 360]]
    };
    
    renderBarChart('#chart_ivrs',data_ivrs);  

    //Binary graphs generated here
    renderSummary({});
    renderFeatured({});
    renderIvrs({});
    renderSurvey({});
    renderWeb({});
    renderComparison({});

  }

  function renderBarChart(elementId, data) {
    var options = {
       axisX: {
        showGrid: false
      },
      axisY: {
        showGrid:false
      }
    };

    var chart_element = Chartist.Bar(elementId, data, options).on('draw', function(data) {
      if(data.type === 'bar') {
        data.element.attr({
          style: 'stroke-width: 20px'
        });
      }
    });
  }

  function renderSummary(data) {
    var tplCountSummary = swig.compile($('#tpl-countSummary').html());
    
    var summaries = {'ivrs':[{
        'label': 'Schools',
        'count': 1000
      },{
        'label': 'Schools with Stories',
        'count': 800
      },{
        'label': 'Calls received',
        'count': 3000
      },{
        'label': 'Academic Year',
        'count': '2015-2016'
      }],
      'survey':[{
        'label': 'Schools',
        'count': 1000
      },{
        'label': 'Schools with Stories',
        'count': 800
      },{
        'label': 'Stories',
        'count': 3000
      },{
        'label': 'Academic Year',
        'count': '2015-2016'
      }],
      'web':[{
        'label': 'Schools',
        'count': 1000
      },{
        'label': 'Schools with Stories',
        'count': 800
      },{
        'label': 'Verified Stories',
        'count': 3000
      },{
        'label': 'Academic Year',
        'count': '2015-2016'
      }] };
    var html = tplCountSummary({'summary':summaries['ivrs']});
    $('#ivrssummary').html(html);
    html = tplCountSummary({'summary':summaries['survey']});
    $('#surveysummary').html(html);
    html = tplCountSummary({'summary':summaries['web']});
    $('#websummary').html(html);    
  }

  function renderFeatured(data) {
    var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
    
    var questions = [{
        'question': 'IVRS: How many schools had all teachers present on the Day of Visit?',
        'score': 440,
        'total': 1000,
        'percent': 44
      },{
        'question': 'IVRS: How many schools had classes being conducted?',
        'score': 260,
        'total': 1000,
        'percent': 26
      },{
        'question': 'Surveys: How many schools had functional toilets?',
        'score': 300,
        'total': 1000,
        'percent': 30
      },{
        'question': 'Surveys: How many schools had drinking water?',
        'score': 440,
        'total': 1000,
        'percent': 44
      }];
    
    var html = ''
    for (var pos in questions) {
      html = html + tplPercentGraph(questions[pos]);
    } 
    $('#quicksummary').html(html);    
  }

  function renderIvrs(data) {
    var tplGradeGraph = swig.compile($('#tpl-gradeGraph').html());
    var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
    //define your data
    var grades = [{
        'value': 'A',
        'score': 440,
        'total': 1000,
        'percent': 44,
        'color':'green-leaf'
      },{
        'value': 'B',
        'score': 260,
        'total': 1000,
        'percent': 26,
        'color':'orange-mild'
      },{
        'value': 'C',
        'score': 300,
        'total': 1000,
        'percent': 30,
        'color':'pink-salmon'
    }];

    var html = ''
    for (var pos in grades) {
      html = html + "<div class='chart-athird-item'>" + tplGradeGraph(grades[pos]) + "</div>";
    } 
    $('#ivrsgrades').html(html);

    var questions = [{
        'question': 'How many schools were open on the day of visit?',
        'score': 440,
        'total': 1000,
        'percent': 44
      },{
        'question': 'In how many schools was the Headmaster present?',
        'score': 260,
        'total': 1000,
        'percent': 26
      },{
        'question': 'In how many schools were the toilets in good condition?',
        'score': 300,
        'total': 1000,
        'percent': 30
    }];
    
    html = ''
    for (var pos in questions) {
      html = html + tplPercentGraph(questions[pos]);
    } 
    $('#ivrsquestions').html(html);    
  }

  function renderSurvey(data) {
    var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
    
    var questions = [{
        'question': 'How many schools are the teachers regular?',
        'score': 440,
        'total': 1000,
        'percent': 44
      },{
        'question': 'How many schools have sufficient teachers?',
        'score': 260,
        'total': 1000,
        'percent': 26
      },{
        'question': 'In how many schools are teachers taking classes regularly?',
        'score': 300,
        'total': 1000,
        'percent': 30
      },{
        'question': 'How many schools have children getting academic attenction?',
        'score': 440,
        'total': 1000,
        'percent': 44
      },{
        'question': 'In how many schools are SDMC members involved?',
        'score': 260,
        'total': 1000,
        'percent': 26
      },{
        'question': 'In how many schools are there no concerns about Mid-day Meals?',
        'score': 300,
        'total': 1000,
        'percent': 30
    }];
    
    var html = "<div class='chart-half-item'>";
    for (var pos in questions) {
      if (pos == questions.length/2) {
        html = html + "</div><div class='chart-half-item'>";
      }
      html = html + tplPercentGraph(questions[pos]); 
    } 
    html = html + "</div>";
    $('#surveyquestions').html(html);    
  }

  function renderWeb(data) {
    var tplPercentGraph = swig.compile($('#tpl-percentGraph').html());
    
    var questions = [{
        'question': 'Where there was evidence of a Mid-day meal served:',
        'score': 440,
        'total': 1000,
        'percent': 44
      },{
        'question': 'Where 50% of children enrolled in the school were present:',
        'score': 260,
        'total': 1000,
        'percent': 26
      },{
        'question': 'Where all the teachers for all classes were present:',
        'score': 300,
        'total': 1000,
        'percent': 30
      }];
    
    var html = ''
    for (var pos in questions) {
      html = html + "<div class='chart-athird-item'>" + tplPercentGraph(questions[pos]) + "</div>";
    } 
    $('#webquestions').html(html);

    var tplColorText = swig.compile($('#tpl-colorText').html());

    var facilities = [{
        'facility': 'All weather pucca building',
        'icon': ['fa fa-university'],
        'percent': 44
      },{
        'facility': 'Playground',
        'icon': ['fa fa-futbol-o'],
        'percent': 45
      },{
        'facility': 'Drinking Water',
        'icon': ['fa  fa-tint'],
        'percent': 54
       },{
        'facility': 'Library',
        'icon': ['fa fa-book'],
        'percent': 64
      },{
        'facility': 'Toilets',
        'icon': ['fa fa-male','fa fa-female'],
        'percent': 74
      },{
        'facility': 'Secure Boundary Wall',
        'icon': ['fa fa-circle-o-notch'],
        'percent': 34
      }];

    var html = ''
    for (var pos in facilities) {
      html = html + tplColorText(facilities[pos]);
    } 
    $('#webfacilities').html(html);
    
  }

  function renderComparison(data) {
    var tplCompareTable = swig.compile($('#tpl-compareTable').html());

    var neighbours = [{
        'name': 'Bangalore North',
        'schools': 1000,
        'stories': 440,
        'needs_volunteer': 'Playground',
        'needs_community': 'Playground',
        'ivrs': 500
      },{
        'name': 'Bangalore South',
        'schools': 1000,
        'stories': 540,
        'needs_volunteer': 'Drinking Water',
        'needs_community': 'Mid-day Meals',
        'ivrs': 600
      },{
        'name': 'Bangalore Central',
        'schools': 1000,
        'stories': 640,
        'needs_volunteer': 'Drinking Water',
        'needs_community': 'Playground',
        'ivrs': 600
      },{
        'name': 'Bangalore Rural',
        'schools': 1000,
        'stories': 740,
        'needs_volunteer': 'Playground',
        'needs_community': 'Mid-day Meals',
        'ivrs': 600
      }];

    var html = tplCompareTable({'neighbours':neighbours});
    $('#comparison').html(html);

  }

})();
