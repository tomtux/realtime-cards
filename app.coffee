express = require "express"
http = require "http"
app = express()
auth = require "./config/middlewares/authorization"
server = http.createServer(app)
io = require("socket.io").listen(server)
passport = require "passport"
fs = require "fs"

# # bootstrap env config
# config = require "config"

# console.log config

# for attr_name in config
#   # console.log "attr_name = #{attr_name}"
#   process.env[attr_name] ||= config[attr_name]

# console.log process.env

# bootstrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  require models_path + "/" + file

# bootstrap mincer config
require('./config/initializers/mincer')(app)

# bootstrap passport config
require("./config/initializers/passport")(passport)

# bootstrap socket.io config
require('./config/initializers/socket.io')(io)

# bootstrap db connection
mongoose = require "mongoose"
uristring = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL
mongoose.connect uristring

# bootstrap express config
require('./config/initializers/express')(app, passport)

# bootstrap routes
require("./config/routes")(app, passport, auth)

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")