new Chartist.Bar('#chart1', {
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  series: [
  {
    name: 'Call Volume',
    data: [500, 1200, 1000, 700, 540, 1030, 360]
  }]
}, {
  axisX: {
    showGrid: false
  },
  axisY: {
    showGrid: true
  }
});


new Chartist.Line('#chart2', {
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
  colors: ['$green-leaf','$orange-mild'],
  series: [
    {
      name: 'Green Level',
      data: [100, 230, 50, 50, 80, 130, 90]
    },
    {
      name: 'Orange Level',
      data: [50, 30, 80, 70, 80, 100, 90]
    }
  ]
  },{
    axisX: {
    showGrid: false
  },
  axisY: {
    showGrid: true
  }
});


var $chart = $('.ct-chart');

var $toolTip = $chart
  .append('<div class="tooltip"></div>')
  .find('.tooltip')
  .hide();

$chart.on('mouseenter', '.ct-point', function() {
  var $point = $(this),
    value = $point.attr('ct:value'),
    seriesName = $point.parent().attr('ct:series-name');
  $toolTip.html(seriesName + '<br>' + value).show();
});

$chart.on('mouseleave', '.ct-point', function() {
  $toolTip.hide();
});

$chart.on('mousemove', function(event) {
  $toolTip.css({
    left: (event.offsetX || event.originalEvent.layerX) - $toolTip.width() / 2 - 10,
    top: (event.offsetY || event.originalEvent.layerY) - $toolTip.height() - 40
  });
});


/*----------------------CHART JS ------------------*/
    var randomScalingFactor = function(){ return Math.round(Math.random()*100)};
    var lineChartData = {
      labels : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      datasets : [
        {
          label: "Green Level",
          fillColor : '$green-leaf',
          strokeColor : '$green-leaf',
          pointColor : '$green-leaf',
          pointStrokeColor : '$green-leaf',
          pointHighlightFill : '$green-leaf',
          pointHighlightStroke : '$green-leaf',
          data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
        },
        {
          label: "Orange Level",
          fillColor : '$orange-mild',
          strokeColor : '$orange-mild',
          pointColor : '$orange-mild',
          pointStrokeColor : '$orange-mild',
          pointHighlightFill : '$orange-mild',
          pointHighlightStroke : '$orange-mild',
          data : [randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor(),randomScalingFactor()]
        }
      ]

    }

  window.onload = function(){
    var ctx = document.getElementById("chart3").getContext("2d");
    window.myLine = new Chart(ctx).Line(lineChartData, {
      responsive: true
    });
  }


window.PykChartsInit = function (e) {
        var k = new PykCharts.oneD.bubble({
            "selector": "#chart5",
            "data": [{"name": "Hello","weight": 8819342},{"name": "World","weight": 612463,"tooltip":"<b>HTML tooltip, huh?</b>But I am optional."}],
        });
        k.execute();
    
        var j = new PykCharts.multiD.bar({
        'data':'name, weight\nIndia,400\nUSA,600',
        'selector':'#chart6',
        'mode': "default",
        'color_mode': "saturation",
        'chart_color':["steelblue"],
        'background_color':"white",
        'chart_height': 430,
        'chart_width' : 700,
        'chart_margin_top': 25,
        'chart_margin_right': 25,
        'chart_margin_bottom': 35,
        'chart_margin_left': 130 
        });
        j.execute();
    }