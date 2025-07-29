const http = require('http');

const PORT = 3000;
const server = http.createServer((req, res) => {
  res.end('Hello from DevOps Case Study!  Deployed by Dhaval Narale');

});

server.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
  console.log("  Deployed by Dhaval Narale 🚀");
});
