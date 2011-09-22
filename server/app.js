
var express = require('express')
var connect = require('connect')
var fs = require('fs')
var path = require('path')
var Flow = require('./lib/Flow')
var geo = require('./lib/geo')
var Family = require('./model/Family')

exports.createServer = function() {
    var app = express.createServer()   
    var mockDir = path.join(__dirname, "mock")  
    var uid = 0
    var cachedFamilies = null          
    
    app.use(connect.bodyParser())
    
    app.get('/families', function(req, res) {
        cacheFamilies(function(err, families) {
            if (err) return res.send(err)             
            res.send(families)                            
        })
    })          
    
    app.get('/family/:uid', function(req, res) {    
        var uid = parseInt(req.params.uid, 10)     
        cacheFamilies(function(err, families) {
            if (err) return res.send(err)
            var family = findFamily(uid)
            if (!family) return res.send(404)
            res.send(family)
        })
    })
    
    app.post('/family/:uid/note', function(req, res) {
        var uid = parseInt(req.params.uid, 10)
        cacheFamilies(function(err, families) {
            if (err) return res.send(err)
            var family = findFamily(uid)
            if (!family) return res.send(404)

            family.notes = family.notes || []
            family.notes.push(req.body.note)

            res.send(200)            
        })
    })
              
    function findFamily(uid) {
        return cachedFamilies.filter(function(family) {
            return (family.uid == uid)
        })[0]        
    }     
    
    function cacheFamilies(cb) {
        if (cachedFamilies) return cb(null, cachedFamilies)
        
        fs.readFile(path.join(mockDir, "families.json"), function(err, data) {
            if (err) return cb(err)
            var families = JSON.parse(data.toString())
            var left = families.length
            
            families.forEach(function(family) {   
                family.uid = uid++
                geo.locationForSearch(Family.fullAddress(family), function(err, point) {
                    if (err) return cb(err)                                             
                    family.lat = point.lat
                    family.lon = point.lon
                    if (--left <= 0) 
                        finish()   
                })
            }) 
            
            function finish(err) {     
                if (err) return cb(err) 
                cachedFamilies = families
                cb(null, cachedFamilies)
            }
        })                                                                           
        
    }
    
    return app
}

if (module == require.main) {   
    var app = exports.createServer()     
    console.log("Listening on 2555")
    app.listen(2555)
}