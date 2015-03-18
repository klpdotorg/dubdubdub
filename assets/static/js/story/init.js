'use strict';
(function() {
  klp.init = function() {
    var data_respondant = {
      labels: ['Parents', 'Teachers', 'Community', 'Staff', 'Volunteers', 'Others'],
      series: [[80,200,100,80,200,100]]
    };
    renderBarChart('#chart_respondant',data_respondant);
    var data_ivrs = {
      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
      series: [[500, 1200, 1000, 700, 540, 1030, 360]]
    };
    renderBarChart('#chart_ivrs',data_ivrs);


    function renderBarChart(chart_type,data) {
      var options = {
         axisX: {
          showGrid: false
        },
        axisY: {
          showGrid:false
        }
      };

      new Chartist.Bar(chart_type, data, options).on('draw', function(data) {
        if(data.type === 'bar') {
          data.element.attr({
            style: 'stroke-width: 20px'
          });
        }
      });
    }
  }//Close klp.init
})();


