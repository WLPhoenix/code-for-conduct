var express = require('express')
var app = express()

app.get('/eb/evt', function (req, res) {
  res.send([{
    id: 0,
    name: "Event 1",
    address: "123 Elmer St, Nashville, TN"
  },
  {
    id: 1,
    name: "Event 2",
    address: "321 Elmer St, Nashville, TN"
  }]);
});

app.post('/question', function (req, res) {
  res.send({
    htmlData: "<div><h2>testing header</h2></div>",
    conductID: 0
  })
});

app.post('/conduct', function (req, res) {
  res.send({});
});

app.post('/conduct/send', function (req, res) {
  res.send({});
});

app.post('/conduct/staff', function (req, res) {
  res.send({});
});

app.get('/conduct/:id/staff', function (req, res) {
  res.send([
    {name:"sam", phone:"(314) 323-2323"},
    {name:"max", phone:"(323) 525-1932"}
  ]);
});

app.get('/conduct/:id/report', function (req, res) {
  res.send([
    {reportID: 0, name:"sam", email:"sam@g.com", description:"they did things..."},
    {reportID: 1, name:"max", email:"max@g.com", description:"bad stuff happened"}
  ]);
});

app.get('/conduct/:cid/report/:id', function (req, res) {
  res.send(
    {reportID: 0, name:"sam", email:"sam@g.com", description:"they did things..."}
  );
});

app.use('/', express.static(__dirname));

var server = app.listen(3000, function () {

  var host = server.address().address
  var port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)

})
