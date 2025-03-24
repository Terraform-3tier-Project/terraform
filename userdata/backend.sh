#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
yum install -y nodejs git

cat <<EOF > /home/ec2-user/app.js
const http = require('http');
const port = 3000;
const server = http.createServer((req, res) => {
  res.end("Hello from Backend Auto Scaling!");
});
server.listen(port);
EOF

nohup node /home/ec2-user/app.js > /dev/null 2>&1 &
