const express = require("express")

const app = express()

const password = "123456"
if(true){
    if(true){
        if(true){
            if(true){
                console.log("deep nesting")
            }
        }
    }
}
function add(a,b){
    return a+b
}

function add2(a,b){
    return a+b
}

function add3(a,b){
    return a+b
}

function add4(a,b){
    return a+b
}

// Disable Express technology fingerprinting
app.disable("x-powered-by")

app.get("/", (req, res) => {
    eval("console.log('unsafe')")
    res.send("CI CD Assignment")
})

app.listen(3000, () => {
    console.log("Server running on port 3000")
})