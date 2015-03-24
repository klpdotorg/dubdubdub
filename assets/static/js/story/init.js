'use strict';
(function() {
  klp.init = function() {
    var data_respondant = {
      labels: ['Parents', 'Teachers', 'Community', 'Staff', 'Volunteers', 'Others'],
      series: [[80,200,100,80,200,100]]
    };
    var respondant_chart;
    klp.renderBarChart(respondant_chart,'#chart_respondant',data_respondant);
  }//Close klp.init
})();


(function() {
  klp.updateChart = function(chart_element){
    var data_ivrs = {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      series: [[500, 1200, 1000, 700, 540, 1030, 360]]
    };
    var ivrs_chart;
    klp.renderBarChart(ivrs_chart,'#chart_ivrs',data_ivrs);   
  }
})();

(function() {
  klp.renderBarChart= function(chart_element,chart_type,data) {
    var options = {
       axisX: {
        showGrid: false
      },
      axisY: {
        showGrid:false
      }
    };

    chart_element = Chartist.Bar(chart_type, data, options).on('draw', function(data) {
      if(data.type === 'bar') {
        data.element.attr({
          style: 'stroke-width: 20px'
        });
      }
    });
  }
})();
