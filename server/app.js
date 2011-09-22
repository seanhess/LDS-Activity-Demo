
var express = require('express')
var fs = require('fs')
var path = require('path')
var Flow = require('./lib/Flow')
var geo = require('./lib/geo')
var Family = require('./model/Family')

exports.createServer = function() {
    var app = express.createServer()   
    var mockDir = path.join(__dirname, "mock")
    
    app.get('/families', function(req, res) {
        fs.readFile(path.join(mockDir, "families.json"), function(err, data) {
            if (err) return res.send(err)
            var families = JSON.parse(data.toString())
            var left = families.length
            
            families.forEach(function(family) {   
                geo.locationForSearch(Family.fullAddress(family), function(err, point) {
                    if (err) return cb(err)                                             
                    family.lat = point.lat
                    family.lon = point.lon
                    if (--left <= 0) 
                        finish()   
                })
            })                                                                
            
            function finish(err) {     
                if (err) return res.send(err)
                res.send(families)                
            }
        })
    })
    
    return app
}

if (module == require.main) {
    var app = exports.createServer()     
    console.log("Listening on 2555")
    app.listen(2555)
}