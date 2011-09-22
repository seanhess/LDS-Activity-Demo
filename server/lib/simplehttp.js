////////////////////////
// Simple Http Client //
////////////////////////

var http = require('http'),
    https = require('https'),
    sys = require('sys'),
    url = require('url'),
    _ = require('underscore');

////////////////
// contstants //
////////////////

exports.OK = 200
exports.NoContent = 204
exports.Found = 302
exports.MovedPermanently = 301
exports.BadRequest = 400
exports.StatusCodeMessages = {}
exports.StatusCodeMessages[exports.OK] = "OK"
exports.StatusCodeMessages[exports.Found] = "Found"
exports.StatusCodeMessages[exports.MovedPermanently] = "Moved Permanently"
exports.StatusCodeMessages[exports.BadRequest] = "Bad Request"
exports.StatusCodeMessages[exports.NoContent] = "No Content"

////////////////////
// public methods //
////////////////////

// uncomment or overwrite to see traffic
exports.debug = function(message) {
    // console.log(message)
}

// handles GET requests
exports.get = function(urlString, headers, cb) {
    exports.send("GET", urlString, headers, cb)
}

// Automatically serializes JSON objects and sets the 
// appropriate headers if necessary
// headers is optional
exports.post = function(urlString, headers, body, cb) {

    if (typeof body === "function") {
        cb = body
        body = headers
        headers = {}
    }
    
    exports.send("POST", urlString, headers, body, cb)    
}

// handles PUT requests
exports.put = function(urlString, headers, body, cb) {
    
    if(typeof body === "function") {
        cb = body
        body = headers
        headers = {}
    }
    
    exports.send("PUT", urlString, headers, body, cb)    
}

// handles DEL requests
exports.del = function(urlString, headers, cb) {
    exports.send("DELETE", urlString, headers, cb)
}

// handles HEAD requests
exports.head = function(urlString, headers, cb) {
	exports.send("HEAD", urlString, headers, cb)
}

// sends a full request
exports.send = function(method, urlString, headers, body, cb) {
    var parsedUrl = new Url(urlString),
        client = new Client(parsedUrl);
    
    client.send(method, parsedUrl.pathAndQuery, headers, body, cb)
}

// get's the status code for a specific call
exports.getStatusCode = function(urlString, cb) {
    var parsedUrl = new Url(urlString),
        client = new Client(parsedUrl);
    client.sendRich({path: parsedUrl.pathAndQuery, statusCode: true}, cb)
}

exports.Response = Response;
exports.Url = Url;
exports.Client = Client;

/////////////
// Classes //
/////////////

function Client(url) {
    this.url = (url instanceof Url) ? url : new Url(url);
    this.agent = (this.url.https) ? https : http;  
    
    this.headers = {
        "Host": this.url.hostname
    };

};


Client.prototype.send = function(method, path, headers, body, cb) {

    // optional fields
	if (typeof headers === 'function') {
        cb = headers
        body = ""
        headers = {}
    } else if (typeof body === 'function') {
        cb = body
        body = ""
    }
    
	this.sendRich({method: method, path: path, headers: headers, body: body}, cb)
}

//  Params:
// method - optional, default GET
// path - required
// headers - optional
// body - optional
// statusCode - (just call back with status code) - optional - default false
Client.prototype.sendRich = function(params, cb) {
    
    var req,
        options;
    
	params.body = params.body  || "";
	params.headers = params.headers || {};
	params.method = params.method || "GET";
    
    // convert non-string body to json
    if (typeof params.body !== 'string') {
        params.body = JSON.stringify(params.body);
        params.headers["Content-Type"] = "application/json";
        params.headers["Accept"] = "application/json";
    }
    
    params.headers["Content-Length"] = params.body.length;
    params.headers = _(this.headers).extend(params.headers);
    
    options = {
        host: this.url.hostname,
        port: this.url.port,
        path: params.path,
        headers: params.headers,
        method: params.method
    };
    //console.log(options)
    req = this.agent.request(options);
    
    exports.debug(">>>>>>>>>>>>>\n" + this.url.port + " " + this.url.hostname + " " + this.url.https + "\n" + requestString(req))
    exports.debug(params.body)

    req.on('error', function(err) {
        cb(err)
    })

    req.on('response', function(res) {
        
        var data = "";

        res.on('data', function(chunk) {
            data += chunk;
        })

        res.on('end', function() {
        
            var responseObject = new Response(res, data),
                url,
                client;

            // Automatically Redirect in the case of a 301
            if (params.method == "GET" && res.statusCode == exports.Found || res.statusCode == exports.MovedPermanently) {
                url = new Url(res.headers.location)
				client = new Client(url)					
				return client.sendRich({
				    path: url.pathAndQuery,
				    statusCode: params.statusCode
				}, cb);
            }                
            
            exports.debug("<<<<<<<<<<<<\n" + responseObject)
            cb(null, params.statusCode ? res.statusCode : responseObject)
        })
    })
    
    // req.on('close', function(hadError) {
    //
    // })
    //
    // req.on("timeout", function() {
    // 
    // })
    // 
    // req.on('end', function() {
    //
    // })
    
    req.end(params.body, "utf8")        
}

function Response(res, data) {
	
	this.parsedJson;
    
    this.httpVersion = "1.1"
    
    this.__defineGetter__('data', function() {
        return data;
    });
    
    this.__defineGetter__('statusCode', function() {
        return res.statusCode;
    })    
    
    this.__defineGetter__('headers', function() {
        return res.headers
    })
    
    this.__defineGetter__('json', function() {

		if (!this.parsedJson) {

	        try {
				this.parsedJson = JSON.parse(data)
	        } catch (e) { 
				exports.debug("SIMPLEHTTP JSON ERROR " + data)
                exports.debug(sys.inspect(e))
			}			
			
		}
		return this.parsedJson
    })
    
}

Response.prototype.toString = function() {

    var out = "HTTP/" + this.httpVersion + " "+ this.statusCode + " " + getStatusCodeMessage(this.statusCode);
    
    for (var header in this.headers) {
        out += "\n" + header + ": " + this.headers[header];
    }
    
    out += "\n\n" + this.data;
            
    return out;
}


function Url(urlString) {
    
    var parsedUrl = url.parse(urlString);
    this.urlString = urlString;
    
    this.__defineGetter__('baseUrl', function() {
        return parsedUrl.protocol + "//" + host;
    });
    
    this.__defineGetter__('hostname', function() {
        return parsedUrl.hostname;
    });
    
    this.__defineGetter__('path', function() {
        return parsedUrl.pathname || "/";
    });
    
    this.__defineGetter__('query', function() {
        return parsedUrl.query  || ""
    });
    
    this.__defineGetter__('search', function() {
        return parsedUrl.search  || "";
    });
    
    this.__defineGetter__('https', function() {
        return (parsedUrl.protocol == "https:");
    });
    
    this.__defineGetter__('href', function() {
        return parsedUrl.href
    });
    
    this.__defineGetter__('port', function() {
        if (parsedUrl.port) return parsedUrl.port
        return this.https ? 443 : 80
    });

    this.__defineGetter__('pathAndQuery', function() { 
        return this.path + this.search;
    });
}

Url.prototype.toString = function() {
    return this.urlString
}

/////////////////////
// Private Methods //
/////////////////////

function requestString(req) {
    var out = req.method + " " + req.path + " HTTP 1.1";
    for (var header in req._headers) {
        out += "\n" + header + ": " + req._headers[header];
    }
    return out;
}

function getStatusCodeMessage(code) {
    return exports.StatusCodeMessages[code] || "";
}