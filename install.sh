#/bin/bash
mkdir registry
mkdir -p registry/{nginx,auth}
mkdir -p registry/nginx/conf.d

cp ./registry.conf ./registry/nginx/conf.d/registry.conf 
cp ./additional.conf ./registry/nginx/conf.d/additional.conf 


cd ./registry/auth

echo "Insert a Username:"
$username = read()

htpasswd -Bc registry.passwd $username

echo "Creating container...."
docker compose up -d

cat ./../howto.txt