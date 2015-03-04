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

