expect = require('chai').expect

Express = require 'express'
path = require 'path'
request = require 'supertest'

app = new Express()
app.get '/', (req, res) ->
  res.render('index.js', {title: 'foo'})

ViewReactor = require '../src/view-reactor'
ViewReactor.init({views_path: path.join(__dirname, '..', 'support', 'views'), base_uri: '/_views'})

describe 'ViewReactor', ->
  it 'should provide a view engine', ->
    app.engine('js', ViewReactor.Engine())
    app.set('view engine', 'view-reactor')
    app.set('views', path.join(__dirname, '..', 'support', 'views'))

  it 'should provide middleware', ->
    app.use ViewReactor.Middleware()

  it 'should render a react file and send it', (done) ->
    request(app)
      .get('/')
      .expect(200)
      .expect(/\/_views\/index\.js/)
      .expect(/Hello/, done)

  it 'should be generating a full page', (done) ->
    request(app)
      .get('/')
      .expect(/<head/)
      .expect(/<body/)
      .expect(/<div/)
      .expect(/id="app"/, done)

  it 'should be serving views over middleware', (done) ->
    request(app)
      .get('/_views/index.js')
      .expect(200)
      .expect(/component/, done)

  it 'should resend the already generated bundle', (done) ->
    console.log 'this test should take much less time than the previous one'
    request(app)
      .get('/_views/index.js')
      .expect(200)
      .expect(/component/, done)
