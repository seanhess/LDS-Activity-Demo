
var express = require('express')
var fs = require('fs')
var path = require('path')

exports.createServer = function() {
    var app = express.createServer()   
    var mockDir = path.join(__dirname, "mock")
    
    app.get('/families', function(req, res) {
        fs.readFile(path.join(mockDir, "families.json"), function(err, data) {
            if (err) return res.send(err)
            var families = JSON.parse(data.toString())
            res.send(families)
        })
    })
    
    return app
}

if (module == require.main) {
    var app = exports.createServer()     
    console.log("Listening on 2555")
    app.listen(2555)
}