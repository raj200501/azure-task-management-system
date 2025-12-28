const http = require('http');

const port = process.env.MOCK_BACKEND_PORT || 5000;

const tasks = [
  { id: 1, name: 'Design Database', description: 'Design the project database schema.', priority: 'High', isComplete: false },
  { id: 2, name: 'Implement API', description: 'Develop the RESTful API.', priority: 'Medium', isComplete: false }
];

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  if (req.url === '/api/task' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(tasks));
    return;
  }

  if (req.url === '/api/task' && req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk;
    });
    req.on('end', () => {
      try {
        const task = JSON.parse(body || '{}');
        const nextId = tasks.length + 1;
        const saved = { id: nextId, ...task };
        tasks.push(saved);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(saved));
      } catch (error) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Invalid JSON payload' }));
      }
    });
    return;
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'Not found' }));
});

server.listen(port, () => {
  console.log(`Mock backend running on http://localhost:${port}`);
});
