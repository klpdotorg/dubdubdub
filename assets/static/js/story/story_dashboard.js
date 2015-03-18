var options = {
   axisX: {
    showGrid: false
  },
  axisY: {
    showGrid:false
  }
};

var data_respondant = {
   labels: ['Parents', 'Teachers', 'Community', 'Staff', 'Volunteers', 'Others'],
  series: [[80,200,100,80,200,100]]
};


new Chartist.Bar('#chart_respondant', data_respondant, options).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});

var data_ivrs = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
    series: [[500, 1200, 1000, 700, 540, 1030, 360]]
};

new Chartist.Bar('#chart_ivrs',data_ivrs,options).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});

