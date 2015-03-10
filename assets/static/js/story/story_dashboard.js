new Chartist.Bar('#chart_respondant', {
  labels: ['Parents', 'Teachers', 'Community', 'Staff', 'Volunteers', 'Others'],
  series: [[80,200,100,80,200,100]]
},{
  //stackBars: true,
  axisX: {
    showGrid: false
  },
  axisY: {
    showGrid:false
  }
}).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 30px'
    });
  }
});

new Chartist.Bar('#chart_volume', {
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
}).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});

new Chartist.Bar('#chart_teacher', {
  labels: ['Insufficient TLM','Relation with HM','Work Overload','Training Needs'],
  series: [
  {
    name: 'Teachers\' Concern',
    data: [200, 100, 250, 150]
  }]
}, {
  axisX: {
    showGrid: false
  },
  axisY: {
    showGrid: true
  }
}).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});


new Chartist.Bar('#chart_parent', {
  labels: ['School Administration','Teacher Attendance','Academic Attention','Mid-day meals'],
  series: [
  {
    name: 'Parents\' Concern',
    data: [200, 100, 250, 150]
  }]
}, {
  axisX: {
    showGrid: false
  },
  axisY: {
    showGrid: true
  }
}).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});

new Chartist.Bar('#chart_community', {
  labels: ['Teacher Motivation','Govt. Involvement','PTR','Infrastructure'],
  series: [
  {
    name: 'Community\'s Concern',
    data: [200, 100, 250, 150]
  }]
}, {
  axisX: {
    showGrid: false
  },
  axisY: {
    showGrid: true
  }
}).on('draw', function(data) {
  if(data.type === 'bar') {
    data.element.attr({
      style: 'stroke-width: 20px'
    });
  }
});
