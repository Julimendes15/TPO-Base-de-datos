// index.js
const http = require('http'); // si preferís ESM, más abajo te dejo variante

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type':'text/plain; charset=utf-8'});
  res.end('¡Hola desde Node.js puro!');
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`Servidor en http://localhost:${PORT}`));
