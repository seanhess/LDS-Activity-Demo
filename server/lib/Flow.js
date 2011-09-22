
var nothing = function() {}


// Creates a new parallel callback with join ability. Lets you queue a lot of work up, and will
// bring it all together for you in a nice package. 

var Flow = module.exports = function() {
    this.firstError = null
    this.resultsIndex = 0
    this.results = []
    this.actionsLeft = 0
    this.onComplete = null
    this.returnArray = false
}

// adds the argument to the argument list at the end
// the default one

Flow.prototype.join = function() {
    // save the current index and increment
    // GUARANTEED ORDER

    var self = this
    var index = this.resultsIndex++ 
    
    // Increment the actions left
    this.actionsLeft++
    
    return function(err) { 

        // It saves only the first error that comes back. Throws the rest away (because it assumes you want to exit as soon as possible
        
        if (!this.firstError && err) {
            this.firstError = err
        }
        
        else {
            // Always going to be an array here
            var remainingArguments = Array.prototype.slice.call(arguments, 1)
            self.results[index] = remainingArguments        
        }               
        
        self.checkDone()
    }        
}

Flow.prototype.done = function(cb) {
    this.onComplete = cb         
    process.nextTick(this.checkDone.bind(this))
}

Flow.prototype.asArray = function(cb) {
    this.onComplete = cb
    this.returnArray = true
}
           

Flow.prototype.checkDone = function() {   
    if (--this.actionsLeft <= 0)
        this.complete()    
}

Flow.prototype.complete = function() {
    var self = this    

    // make sure they've had enough time to set it
    process.nextTick(function() {
        var args = []
        
        self.results.forEach(function(orderedResults) {
            args = args.concat(orderedResults)
        })
        
        if (self.returnArray)
            self.onComplete.call(null, self.firstError, args)
            
        else
            self.onComplete.apply(null, [self.firstError].concat(args))
    })
}







/*
OPTION 1:

var join = flow.join()
User.save(user, join.parallel())
Post.save(post, join.parallel()) // forces them to be in order
join(function(err, 





Function.prototype.join = function() {
    // wow! This would be SOOOO cool
    // except you have to pass the parameters RIGHT THEN. 
}


NORMAL CASE: sends back args after err, including nulls, of anything the thing sends back

CASES
1) Find one document, then update two documents based on the result before returning
2) For an array of objects, join a field from another collection on each one
3) Do 6 things that do NOT depend on each other, and check for errs on each one (populate.js)
4) Do 3 things IN ORDER that suck and that depend on external state (writing to files) (bash script) << Bad design
5) Same, but then add a 3rd that returns something about its work that you need on the 7th << Bad design

If they don't depend on each other, just use parallel
If they must be done in order, but do not share parameters: it is bad design, so don't help it. 

// SO, these will always be in parallel

flow.start()
flow.done(function() {})

// PRETENDING!
// You can't pretend this: it really does depend on the actual thing

var user = User.findById.seq(req.body.userId)
User.collection.update.par(





// 1 // giving it a callback "parallel", "
// 2 // calling something when done

// it is a "flow" 
// they are NEVER synchronized (just use callbacks like a normal person)


// A bunch of synchronous stuff can be tedious






*/



if (module == require.main) {
    console.log("HI")
    
    function slow(param, cb) {
        console.log("START " + param)
        process.nextTick(function() {
            console.log("END " + param)
            cb(null, param*2)
        })
    }
    
    // 1 // 
    var flow = new Flow()
    
    // slow(1, flow.join())
    // slow(2, flow.join())    
    
    flow.done(function(err, one, two) {
        console.log(err, one, two)
        
        // 2 // 
        var items = [1,2,3,4]
        var flow = new Flow()

        items.forEach(function(item) {
            slow(item, flow.join())
        })
        
        flow.asArray(function(err, items) {
            console.log(err, items)
        })
    })
}