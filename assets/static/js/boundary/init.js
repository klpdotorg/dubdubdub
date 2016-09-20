'use strict';
(function() {
  var utils;
  var selectedYear;
  var ADMIN_LEVEL_MAP = {
    'district': 'admin_1',
    'block': 'admin_2',
    'cluster': 'admin_3',
    'project': 'admin_2',
    'circle': 'admin_3'
  };
  klp.init = function() {
    utils = klp.boundaryUtils;
    //klp.router = new KLPRouter({});
    //klp.router.init();       
    //klp.router.start();
    setAcadYear()
    render(BOUNDARY_ID, selectedYear);
  };

  function setAcadYear() {
    if (!window.location.hash) {
      window.location.hash = '2014-2015'      
    } 
    selectedYear = window.location.hash.split('#').join('')
  }

  function render(boundaryID, academicYear) {
    var acadYear = academicYear || '2014-2015';


    /*------------------- WISH WASH FOR MAP-------------*/

    var $infoXHR = klp.api.do("aggregation/boundary/" + boundaryID + '/schools/', {
      geometry: 'yes',
      year: acadYear,
      school_type: 'PreSchool',
      source: 'anganwadi',
      from: acadYear.slice(0,4) + "-06-01", // Starts from Jun 1
      to: acadYear.slice(5,9) + "-05-31" // To May 31
    });

    // FIX THIS LATER
    $('#map-canvas').css('zIndex', 1);
    $infoXHR.done(function(data) {
        var boundary = data.properties.boundary;
        var boundaryType = boundary.school_type;
        if (boundaryType === 'primaryschool') {
          renderPrimarySchool(data, acadYear);
        } else {
          renderPreSchool(data, acadYear);
        }        
        // $('.js-trigger-compare').click(function(e) {
        //   e.preventDefault();
        //   klp.comparison.open(data.properties);
        // });        
        $(document).on('change', '#acad-year', function(e){          
          window.location.hash = $( "#acad-year option:selected" ).text()
          window.location.reload()          
        })
        var geom;
        if (boundary.geometry) {
          geom = boundary.geometry;
        } else {
          geom = null;
        }

        if (geom && geom.coordinates) {
          var markerLatlng = L.latLng(geom.coordinates[1], geom.coordinates[0]);
          var map = L.map('map-canvas', {
            touchZoom: false,
            scrollWheelZoom: false,
            doubleClickZoom: false,
            boxZoom: false,
            zoomControl: false,
            attributionControl: false
          }).setView(markerLatlng, 15);

          L.tileLayer(klp.settings.tilesURL, {
            attribution: 'OpenStreetMap, OSM-Bright'
          }).addTo(map);

          var marker = L.geoJson(geom, {
            pointToLayer: function(feature, latLng) {
              return L.marker(latLng, {
                icon: klp.utils.mapIcon("primaryschool_cluster")
              });
            }
          }).addTo(map);

          map.panBy([0, 50], {
            animate: true,
            duration: 0.50
          });
        } else {
          //if school does not have any coordinates, what to do?
          $('.map-canvas').hide();
        }

        var tpl = swig.compile($('#tpl-boundary-info').html());
        var context = data.properties;
        var html = tpl(context);
        $('#boundary-info-wrapper').html(html);
      })
      .fail(function(err) {
        klp.utils.alertMessage("Something went wrong. Please try later.", "error");
      });
  }

  function renderPrimarySchool(data, academicYear) {
    var acadYear = academicYear.replace(/20/g, '')
    var queryParams = {};
    var boundaryName = data.properties.boundary.name;
    var boundaryType = data.properties.boundary.type;
    var boundaryID = data.properties.boundary.id;
    var adminLevel = ADMIN_LEVEL_MAP[data.properties.boundary.type];
    queryParams[adminLevel] = boundaryID;
    $('#school-data').removeClass("hidden");
    klp.dise_api.queryBoundaryName(boundaryName, boundaryType, acadYear)
      .done(function(diseData) {
        var boundary = diseData[0].children[0]
        
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear)
          .done(function(diseData) {            
            renderSummary(utils.getPrimarySchoolSummary(data, diseData, academicYear), 'school');
            renderGenderCharts(utils.getGenderData(data.properties, diseData.properties), 'school');
            renderCategories(utils.getPrimarySchoolCategories(data.properties, diseData.properties), 'school');
            renderInfra(utils.getSchoolInfra(diseData.properties), 'school');
            renderEnrollment(utils.getSchoolEnrollment(data.properties, diseData.properties), "school");
            renderGrants(utils.getGrants(diseData.properties));
          })
          .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not fetch DISE data", "error");
          })
      })
      .fail(function(err) {
        klp.utils.alertMessage("Sorry, could not fetch DISE data", "error");
      });

    renderLanguages(utils.getSchoolsByLanguage(data.properties), 'school');

    klp.api.do('programme/', queryParams)
      .done(function(progData) {
        renderPrograms(utils.getSchoolPrograms(progData, boundaryID, adminLevel), 'primaryschool');
      })
      .fail(function(err) {
        klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
      });
  }

  function renderPreSchool(data, academicYear) {
    var queryParams = {};
    var boundaryID = data.properties.boundary.id;
    var adminLevel = ADMIN_LEVEL_MAP[data.properties.boundary.type];
    queryParams[adminLevel] = boundaryID;
    klp.api.do('programme/', queryParams)
      .done(function(progData) {        
        renderPrograms(utils.getSchoolPrograms(progData, boundaryID, adminLevel), 'preschool');
      })
      .fail(function(err) {
        klp.utils.alertMessage("Sorry, could not fetch programmes data", "error");
      });
    $('#preschool-data').removeClass("hidden");
    renderSummary(utils.getPreSchoolSummary(data, academicYear), 'preschool');
    renderGenderCharts(utils.getGenderData(data.properties), 'preschool');
    renderCategories(utils.getPreSchoolCategories(data.properties), 'preschool');
    renderLanguages(utils.getMotherTongue(data.properties), 'preschool');
    renderEnrollment(utils.getPreSchoolEnrollment(data.properties), "preschool");    
    renderInfra(utils.getPreSchoolInfra(data.properties), "preschool");    
  }

  function renderSummary(data, schoolType) {
    var tpl = swig.compile($('#tpl-school-summary').html());
    data["school_type"] = schoolType;
    var html = tpl(data);
    if (schoolType == "school") {
      $('#school-summary').html(html);
    }
    else {
      $('#preschool-summary').html(html);
    }
    $('#acad-year').val(selectedYear)
  }

  function renderGenderCharts(data, schoolType) {
    var tpl = swig.compile($('#tpl-gender-summary').html());
    var gender = null;
    var html = tpl(gender);
    var prefix = '';
    if (schoolType == "school") {
      gender = {
        "gender": data["dise"]
      };
      html = tpl(gender);
      $('#dise-gender').html(html);
      gender = {
        "gender": data["klp"]
      };
    } else {
      prefix = "ang-";
      gender = {
        "gender": data["klp"]
      };
      gender["gender"]["align"] = "left";
    }
    html = tpl(gender);
    $('#' + prefix + 'klp-gender').html(html);
  }

  function renderCategories(data, schoolType) {    
    var tpl_func = '#tpl-category-summary';
    var prefix = '';
    if (schoolType == "preschool") {
      prefix = "ang-";
      tpl_func = '#tpl-ang-category-summary';
    }
    var tpl = swig.compile($(tpl_func).html());
    for(var key in _.keys(data)) {
      var type_name = _.keys(data)[key];
      data[type_name]["type_name"] = type_name;
    }
    var html = tpl({
      "categories": data
    });
    $('#' + prefix + 'category-summary').html(html);
  }

  function renderLanguages(data, schoolType) {   
    var tpl_func = "#tpl-language";
    var prefix = '';
    if (schoolType == "preschool") {
      prefix = "ang-"
      tpl_func = "#tpl-ang-language";
    }
    var tpl = swig.compile($(tpl_func).html());
    var html = tpl({
      "languages": data
    });
    $('#' + prefix + 'klp-language').html(html);
  }

  function renderEnrollment(data, schoolType) {
    var tpl = swig.compile($('#tpl-enrolment').html());
    var prefix = 'dise-';
    if (schoolType == "preschool") {
      prefix = "ang-"
      tpl = swig.compile($('#tpl-ang-enrolment').html());
    }
    for(var key in _.keys(data)) {
      var type_name = _.keys(data)[key];
      data[type_name]["type_name"] = type_name;
    }
    var html = tpl({
      "categories": data
    });
    $('#' + prefix + 'enrolment').html(html);
  }

  function renderGrants(data) {
    drawStackedBar([
      [data["expenditure"]["sg_perc"]],
      [data["expenditure"]["tlm_perc"]]
    ], "#chart-expenditure");
    drawStackedBar([
      [data["received"]["sg_perc"]],
      [data["received"]["tlm_perc"]]
    ], "#chart-received");

    var tpl = swig.compile($('#tpl-grants').html());
    var html = tpl({
      "grants": data["expenditure"]
    });
    $('#dise-expenditure').html(html);
    html = tpl({
      "grants": data["received"]
    });
    $('#dise-received').html(html);
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
          return '';
        }
      }
    }).on('draw', function(data) {
      if (data.type === 'bar') {
        data.element.attr({
          style: 'stroke-width: 20px'
        });
      }
    });
  }

  function renderInfra(facilities, schoolType) {
    var tpl = swig.compile($('#tpl-infra-summary').html());
    var html = '<div class="page-parent">'
    for (var pos in facilities) {
      html = html + tpl(facilities[pos]);
    }
    var prefix = '';
    if (schoolType == "preschool") {
      prefix = "ang-"
    }
    $('#' + prefix + 'infra-summary').html(html + '</div>');

  }

  function renderPrograms(data, schoolType) {
    var tpl = swig.compile($('#tpl-program-summary').html());
    var html = '<div class="page-parent">'
    if(!_.isEmpty(data)) 
    {
      for (var program in data) {
        html = html + '<div class="third-column">' + '<div class="heading-tiny-uppercase">' + program + '</div>' + tpl({
          "programs": data[program]
        }) + '</div>';
      }
    }
    else {
      html = "No Data";
    }
    var prefix = '';
    if (schoolType == "preschool") {
      prefix = "ang-"
    }
    $('#' + prefix + 'program-summary').html(html + '</div>');
  }

})();
