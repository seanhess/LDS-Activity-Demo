var simplehttp = require('./simplehttp')

exports.locationForSearch = function(query, cb) {
    
    var OK = "OK"
    var ZeroResults = "ZERO_RESULTS"
    var OverQueryLimit = "OVER_QUERY_LIMIT"
    var RequestDenied = "REQUEST_DENIED"
    var InvalidRequest = "INVALID_REQUEST"

    /*
    http://code.google.com/apis/maps/documentation/geocoding/#ReverseGeocoding
    http://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&sensor=true_or_false

    address (required) — The address that you want to geocode.*
         OR
    latlng (required) — The textual latitude/longitude value for which you wish to obtain the closest, human-readable address.*
    bounds (optional) — The bounding box of the viewport within which to bias geocode results more prominently. (For more information see Viewport Biasing below.)
    region (optional) — The region code, specified as a ccTLD ("top-level domain") two-character value. (For more information see Region Biasing below.)
    language (optional) — The language in which to return results. See the supported list of domain languages. Note that we often update supported languages so this list may not be exhaustive. If language is not supplied, the geocoder will attempt to use the native language of the domain from which the request is sent wherever possible.
    sensor (required) — Indicates whether or not the geocoding request comes from a device with a location sensor. This value must be either true or false.
    
    See above url for example return format. it's too big to paste here. 
    */
    
    

    var url = "http://maps.google.com/maps/geo?q=" + escape(query)
    simplehttp.get(url, function(err, response) {
        if (err) return cb(err)
        
        var result = response.json
        
        if (!result) return cb(new Error("Geo Request Failed " + url + " " + response))
        
        if (!result.Status || result.Status.code != 200) return cb(new Error("Request Failed " + result.Status + " " + url))
        if (!result.Placemark || !result.Placemark.length) return cb(new Error("No Results " + url))
        
        var placemark = result.Placemark[0]   
        
        /*
        
        { id: 'p1',
          address: '711 E 550 S, Orem, UT 84097, USA',
          AddressDetails: 
           { Accuracy: 8,
             Country: 
              { AdministrativeArea: [Object],
                CountryName: 'USA',
                CountryNameCode: 'US' } },
          ExtendedData: 
           { LatLonBox: 
              { north: 40.288524,
                south: 40.285826,
                east: -111.676842,
                west: -111.67954 } },
          Point: { coordinates: [ -111.678191, 40.287175, 0 ] } }
          
          */
        
        cb(null, {lat: placemark.Point.coordinates[0], lon: placemark.Point.coordinates[1]})
    })
}

if (module == require.main) {
    exports.locationForSearch("711 E 550 S Orem UT", function(err, location) {
        console.log(err, location)
    })
}