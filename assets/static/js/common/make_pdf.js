"use strict";

var page = require('webpage').create(),
    system = require('system'),
    address, output, size;

if (system.args.length < 3 || system.args.length > 5) {
    console.log('Usage: rasterize.js URL filename [paperwidth*paperheight|paperformat] [zoom]');
    console.log('  paper (pdf output) examples: "5in*7.5in", "10cm*20cm", "A4", "Letter"');
    console.log('  image (png/jpg output) examples: "1920px" entire page, window width 1920px');
    console.log('                                   "800px*600px" window, clipped to 800x600');
    phantom.exit(1);
} else {
	address = system.args[1];
    output = system.args[2];
    
    //page.viewportSize = {width: 8.5*150, height: 11*150};
    page.viewportSize = {width: 960, height: 1200};
    //page.zoomFactor = 1.25;
    page.paperSize = { 
        //format: 'A4',
        // margin: {
        //     top: '0.5in',
        //     left: '0in',
        //     bottom: '0.5in',
        //     right: '0in'
        // },
    }
    
    if (system.args.length > 3 && system.args[2].substr(-4) === ".pdf") {
        console.log("First If statement");
        size = system.args[3].split('*');
    	
    } else if (system.args.length > 3 && system.args[3].substr(-2) === "px") {
        console.log("Else If statement");
        size = system.args[3].split('*');
        if (size.length === 2) {
            console.log("Else If If statement");
            pageWidth = parseInt(size[0], 10);
            pageHeight = parseInt(size[1], 10);
            page.viewportSize = { width: pageWidth, height: pageHeight };
            page.clipRect = { top: 0, left: 0, width: pageWidth, height: pageHeight };
        } else {
            console.log("Else If Else statement");
            console.log("size:", system.args[3]);
            pageWidth = parseInt(system.args[3], 10);
            pageHeight = parseInt(pageWidth * 3/4, 10); // it's as good an assumption as any
            console.log ("pageHeight:",pageHeight);
            page.viewportSize = { width: pageWidth, height: pageHeight };
        }
    }
    if (system.args.length > 4) {
        page.zoomFactor = system.args[4];
    }
    page.open(address, function (status) {
        if (status !== 'success') {
            console.log('Unable to load the address!');
            phantom.exit(1);
        } else {
            window.setTimeout(function () {
                page.render(output);
                phantom.exit();
            }, 20000);
        }
    });
}
