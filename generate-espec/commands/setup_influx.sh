#!/usr/bin/env bash

MASTER_NAME=master
MANIFEST_FILE=manifest.xml
MASTER_HOSTNAME=$(xmllint --xpath "string(/*[local-name()='rspec']/*[local-name()='node'][@client_id='$MASTER_NAME']/*[local-name()='host']/@name)" $MANIFEST_FILE)
USER=$(xmllint --xpath "string(/*[local-name()='rspec']/*[local-name()='node'][@client_id='$MASTER_NAME']/*[local-name()='services']/*[local-name()='login']/@username)" $MANIFEST_FILE)

apt-get update
apt-get install -y python-pip adduser libfontconfig apt-transport-https ca-certificates curl software-properties-common

# grafana
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.5.2_amd64.deb
dpkg -i grafana_4.5.2_amd64.deb
sed -i '/^\[auth.anonymous\]$/,/^\[/ s/^;enabled = false/enabled = true/' /etc/grafana/grafana.ini
sed -i '/^\[auth.anonymous\]$/,/^\[/ s/^;org_role = Viewer/org_role = Admin/' /etc/grafana/grafana.ini
service grafana-server start

# influxdb
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.3.5_amd64.deb
dpkg -i influxdb_1.3.5_amd64.deb
service influxdb start

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"apt-get update
# To be fixed: issue with docker-ce version and kubernetes
apt-get install -y docker-ce=17.06.0~ce-0~ubuntu containerd.io
usermod -aG docker $USER

curl -XPOST 'http://localhost:8086/query' --data-urlencode "q=CREATE DATABASE metrics"

sleep 20
curl -XPOST 'http://localhost:3000/api/datasources' -H 'Content-Type: application/json' --data-binary '{"name":"influx","type":"influxdb","url":"http://localhost:8086","access":"proxy","isDefault":true,"database":"metrics"}'

docker run -d -p 5000:5000 --restart=always --name registry -v /mnt/registry:/var/lib/registry registry:2
echo 'export REGISTRY=$(hostname)":5000/"' >> ~/.bashrc
echo 'export INFLUX_DATABASE=metrics' >> ~/.bashrc
echo 'export INFLUX_HOST=$(hostname)' >> ~/.bashrc

git clone https://github.com/brechtvdv/experiment-webserver.git
cd experiment-webserver
pip install -r requirements.txt
python manage.py migrate
cat > setup_superuser.py <<EOL
from django.contrib.auth.models import User
User.objects.create_superuser('admin', 'admin@example.com', 'admin')
EOL
python manage.py shell < setup_superuser.py
python manage.py runserver -6 [::0]:8000
