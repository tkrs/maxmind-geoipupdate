(function() {
  const http = require('http');
  const execSync = require('child_process').execSync;

  const port = process.env.PORT || '8080';

  const handle = function(request, response) {
    response.setHeader('Content-Type', 'application/json');
    try {
      const commandResult = '' + execSync('geoipupdate', ['-v']);
      console.log('result: ' + commandResult);
      response.writeHead(200, {});
      response.end(JSON.stringify({ result: commandResult }));
    } catch (e) {
      console.error('error happend: ' + e.message);
      console.error(e.stack);
      response.writeHead(500, {});
      response.end(JSON.stringify({ errors: [{ message: e.message }] }));
    }
  };

  const server = http.createServer(handle);
  server.listen(port, function() {
    console.log('Listening on port %s', port);
  });
})();
