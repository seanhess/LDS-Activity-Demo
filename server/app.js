
var express = require('express')

exports.createServer = function() {
    var app = express.createServer()
    
    return app
}

if (module == require.main) {
    var app = exports.createServer()     
    console.log("Listening on 2555")
    app.listen(2555)
}