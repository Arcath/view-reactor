Express = require 'express'
path = require 'path'
ViewReactor = require '../src/view-reactor'
ViewReactor.init({views_path: path.join(__dirname, 'views'), base_uri: '/_views', reactURL: "https://fb.me/react-0.13.3.js"})

app = new Express()

app.engine('js', ViewReactor.Engine())
app.engine('coffee', ViewReactor.Engine())
app.set('view engine', 'view-reactor')
app.set('views', path.join(__dirname, 'views'))

app.use ViewReactor.Middleware()

app.get '/', (req,res) ->
  res.render('index.js', {title: 'View Reactor Test-App', name: 'bob'})

app.get '/coffee', (req,res) ->
  res.render('index.coffee', {title: 'View Reactor Test-App', name: 'dave'})

app.listen 3000, ->
  console.log 'listening on port 3000'
