'use strict';
function init() {
        
        renderGrants();
}
   
function renderGrants(){
    var data = { 
        "received": {
            "sg_perc": 25,
            "sg_amt": 3500,
            "smg_perc": 70,
            "smg_amt": 5500,
            "tlm_perc": 5,
            "tlm_amt": 1000   
        },
        "expenditure": {
            "sg_perc": 35,
            "sg_amt": 3500,
            "smg_perc": 55,
            "smg_amt": 5500,
            "tlm_perc": 10,
            "tlm_amt": 1000 
        }
    };
    drawStackedBar([ [data["expenditure"]["sg_perc"]],
                     [data["expenditure"]["smg_perc"]],
                     [data["expenditure"]["tlm_perc"]]
                   ],"#chart-expenditure");
    drawStackedBar([ [data["received"]["sg_perc"]],
                     [data["received"]["smg_perc"]],
                     [data["received"]["tlm_perc"]]
                   ],"#chart-received");


}

function drawStackedBar(data, element_id) {
    new Chartist.Bar(element_id, {
            labels: [''],
            series: data
        }, {
        stackBars: true,
        horizontalBars: true,
        axisX: {
            showGrid: false
        },
        axisY: {
            showGrid: false,
            labelInterpolationFnc: function(value) {
            return'';
        }
    }
    }).on('draw', function(data) {
        if(data.type === 'bar') {
            data.element.attr({
                style: 'stroke-width: 20px'
            });
        }
    });
}
