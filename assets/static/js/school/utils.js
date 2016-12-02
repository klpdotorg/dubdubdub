function searchTable() {
    // Declare variables 
    var id, name, year, id_filter, name_filter, yr_filter;
    // id = document.getElementById("search-id");
    // if(id.value != null) {
    //     id_filter = id.value.toUpperCase();
    //     searchLoop(0,id_filter);    
    // }
    name = document.getElementById("search-name");
    if(name.value != null && name.value != "") {
        name_filter = name.value.toUpperCase();
        searchLoop(1,name_filter);    
    }

    // year = document.getElementById("search-year");
    // if(year.value != null) {
    //    yr_filter = year.value.toUpperCase();
    //     searchLoop(2,yr_filter);    
    // } 
}

 // Loop through all table rows, and hide those who don't match the search query
   
function searchLoop(col_num, filter) {
    var table, tr, td, i;
    table = document.getElementById("sdmc-table");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td")[col_num];
        if (td) {
            if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
                // console.log("display");
            } else {
                tr[i].style.display = "none";
                // console.log("don't display");
            }
        } 
    }
}