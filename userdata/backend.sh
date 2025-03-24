#!/bin/bash
yum update -y



yum install -y ruby wget

cd /home/ec2-user

wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
./install auto

systemctl enable codedeploy-agent
systemctl start codedeploy-agent




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
