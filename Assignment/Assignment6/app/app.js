const express = require("express")

const app = express()

// Disable Express technology fingerprinting
app.disable("x-powered-by")

app.get("/", (req, res) => {
    eval("console.log('unsafe')")
    res.send("CI CD Assignment")
})

app.listen(3000, () => {
    console.log("Server running on port 3000")
})