(function() {
    klp = klp || {};

    var $reports_table = $('#reports-table'),
        $select2_acyear = $('#adhoc-dise-acyear'),
        $select2_admin = $('#adhoc-dise-admin'),
        lists = {
          'mp': ["Tumkur", "Bangalore_Rural", "Shimoga", "Mandya", "Raichur", "Gulbarga", "Bangalore_North", "Hassan", "Dharwad", "Kolar", "Koppal", "Belgaum", "Mysore", "Chikkodi", "Bidar", "Bellary", "Haveri", "Bagalkot", "Bangalore_Central", "Bangalore_South", "Udupi_Chikmagalur", "Bijapur", "Uttara_Kannada", "Chikkballapur", "Dakshina_Kannada", "Chamarajanagar", "Chitradurga", "Davanagere"],
          'mla': ["Sindgi", "Homnabad", "Anekal", "Sirsi", "Rajaji_Nagar", "Indi", "Belgaum_Uttar", "Hungund", "Kagwad", "T.Narasipur", "Gandhi_Nagar", "Maddur", "Shimoga", "Chittapur", "Sidlaghatta", "Mandya", "Bommanahalli", "Kampli", "Nippani", "Tumkur_City", "Yemkanmardi", "Yelburga", "Tumkur_Rural", "Magadi", "Hanur", "Jamkhandi", "Raichur", "Navalgund", "Nagthan", "Nargund", "Arkalgud", "Malleshwaram", "Nanjangud", "Hiriyur", "Shrirangapattana", "Kundapura", "Molakalmuru", "Kunigal", "Tarikere", "Basavanagudi", "Bijapur_City", "Shiggaon", "Sagar", "Jagalur", "Shahapur", "Ranibennur", "Hassan", "Chincholi", "Gulbarga_Uttar", "Shikaripura", "Koratagere", "Hubli-Dharwad-East", "Narasimharaja", "Dharwad", "Kolar", "Belur", "Byadgi", "Nelamangala", "Shimoga_Rural", "Koppal", "Mahadevapura", "Pulakeshinagar", "Padmanaba_Nagar", "Rajarajeshwarinagar", "Kolar_Gold_Field", "Gokak", "Belthangady", "Hosakote", "Tiptur", "Madhugiri", "Bidar", "Chamaraja", "Arsikere", "Virajpet", "Gauribidanur", "Devadurga", "Ramdurg", "Malur", "Chikkodi-Sadalga", "Puttur", "Kundgol", "B.T.M._Layout", "Channapatna", "Bellary", "Basavana_Bagevadi", "Ron", "Challakere", "Krishnaraja", "Sorab", "Afzalpur", "Holenarasipur", "Sandur", "Shravanabelagola", "Hagaribommanahalli", "Kapu", "Sedam", "Lingsugur", "Maski", "Khanapur", "Kudligi", "Chintamani", "Belgaum_Dakshin", "Channagiri", "Chiknayakanhalli", "Haveri", "Hukkeri", "Pavagada", "Govindraj_Nagar", "Byndoor", "Bagalkot", "Chikmagalur", "Bagepalli", "Muddebihal", "Kushtagi", "Karwar", "Babaleshwar", "Raybag", "Ramanagaram", "Davanagere_North", "Varuna", "Bantval", "Kudachi", "Kanakagiri", "Devar_Hippargi", "Mulbagal", "Sarvagnanagar", "Gubbi", "Nagamangala", "Hebbal", "Hangal", "Bangalore_South", "Mudhol", "Arabhavi", "Yelahanka", "Mangalore_City_North", "Turuvekere", "Madikeri", "Kollegal", "Sullia", "Karkal", "Bhadravati", "Gundlupet", "Udupi", "Hubli-Dharwad-West", "C.V._Raman_Nagar", "Doddaballapur", "Melukote", "Malavalli", "Harapanahalli", "Basavakalyan", "Hubli-Dharwad-Central", "Bellary_City", "Mahalakshmi_Layout", "Yadgir", "Mudigere", "Yeshvanthapura", "Gadag", "Hirekerur", "Mangalore_City_South", "Tirthahalli", "Sakleshpur", "Moodabidri", "Vijay_Nagar", "Shanti_Nagar", "Gulbarga_Dakshin", "Kumta", "Raichur_Rural", "Jevargi", "Piriyapatna", "Athani", "Krishnarajpet", "Sira", "Shirahatti", "Belgaum_Rural", "Chamrajpet", "Chikkaballapur", "Davanagere_South", "Chamarajanagar", "Terdal", "Sringeri", "Chitradurga", "Srinivaspur", "Kanakapura", "Aland", "Kalghatgi", "Sindhanur", "Krishnarajanagara", "Hunsur", "Heggadadevankote", "Bhatkal", "Shorapur", "Siruguppa", "Gulbarga_Rural", "Vijayanagara", "Kadur", "Gangawati", "Mangalore", "Devanahalli", "Byatarayanapura", "Bailhongal", "Chamundeshwari", "Hosadurga", "Gurmitkal", "Badami", "Holalkere", "Bangarapet", "Shivajinagar", "Harihar", "Bhalki", "Bidar_South", "Kittur", "Mayakonda", "Dasarahalli", "Chickpet", "K.R._Pura", "Manvi", "Hadagalli", "Aurad", "Jayanagar", "Bilgi", "Honnali", "Saundatti_Yellamma"]
        };

    klp.init = function() {
      console.log("initting dise reports app");

      $select2_acyear.select2({
        minimumResultsForSearch: Infinity
      }).on('change', function(e) {
        var admin = $select2_admin.val();
        if(admin !== '') {
          $('.warning-text').hide();
          $('.reports-list').show();
          $('#heading-acyear').show().html('20' + e.val);
          fillAdmin(e.val, admin);
        }
      });

      $select2_admin.select2({
        minimumResultsForSearch: Infinity
      }).on('select2-selecting', function(e) {
        console.log(e);

        var acyear = $select2_acyear.val();

        if(!acyear) {
          alert('Please select an academic year');
          return false;
        } else {
          $('.warning-text').hide();
          $('.reports-list').show();
          fillAdmin(acyear, e.val);
        }
      });
    };

    var fillAdmin = function(acyear, adminlevel) {
      var url_base = 'https://klp.org.in/public/adhoc-dise-reports',
          url = url_base + '/reports_dise_' + acyear.replace('-', ''),
          dise_base = 'https://dise.klp.org.in/api/';

      $reports_table.find('tbody').html('');

      if (adminlevel === 'cluster') {
      } else if (adminlevel === 'block') {
      } else if (adminlevel === 'district') {
        $.getJSON(dise_base + acyear + '/district/?basic=yes', function(response) {
          $.each(response.results.features, function(key, val) {
            var district_name = val.properties.district,
                district_slug = district_name.replace(/\ /g, '_');

            $reports_table.find('tbody')
              .append($('<tr>'))
                .append($('<td>')
                  // name
                  .text(district_name)
                )
                .append($('<td>')
                  .append($('<a>')
                    .attr('href', url + '/district/infrastructure/' + district_slug + '_english.pdf')
                    .text('English')
                  )
                  .append(' | ')
                  .append($('<a>')
                    .attr('href', url + '/district/infrastructure/' + district_slug + '_kannada.pdf')
                    .text('Kannada')
                  )
                )
                .append($('<td>')
                  .append($('<a>')
                    .attr('href', url + '/district/demographics/' + district_slug + '_english.pdf')
                    .text('English')
                  )
                  .append(' | ')
                  .append($('<a>')
                    .attr('href', url + '/district/demographics/' + district_slug + '_kannada.pdf')
                    .text('Kannada')
                  )
                )
                .append($('<td>')
                  .append($('<a>')
                    .attr('href', url + '/district/finance/' + district_slug + '_english.pdf')
                    .text('English')
                  )
                  .append(' | ')
                  .append($('<a>')
                    .attr('href', url + '/district/finance/' + district_slug + '_kannada.pdf')
                    .text('Kannada')
                  )
                )
          })
        });
      } else if (adminlevel === 'mp') {
        $.each(lists['mp'].sort(), function(idx, val) {
          $reports_table.find('tbody')
            .append($('<tr>'))
              .append($('<td>')
                // name
                .text(val)
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mp/infrastructure/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mp/infrastructure/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mp/demographics/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mp/demographics/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mp/finance/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mp/finance/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
        })
      } else if (adminlevel === 'mla') {
        $.each(lists['mla'].sort(), function(idx, val) {
          $reports_table.find('tbody')
            .append($('<tr>'))
              .append($('<td>')
                // name
                .text(val)
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mla/infrastructure/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mla/infrastructure/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mla/demographics/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mla/demographics/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
              .append($('<td>')
                .append($('<a>')
                  .attr('href', url + '/mla/finance/' + val + '_english.pdf')
                  .text('English')
                )
                .append(' | ')
                .append($('<a>')
                  .attr('href', url + '/mla/finance/' + val + '_kannada.pdf')
                  .text('Kannada')
                )
              )
        })
      }
    }
})();
