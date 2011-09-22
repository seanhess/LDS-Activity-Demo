var Family = module.exports

Family.fullAddress = function(doc) {
    return doc.address + " " + doc.city + " " + doc.state + " " + doc.postalCode
}