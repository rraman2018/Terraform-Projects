#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html

sudo mke2fs -F -j /dev/sdf
sudo mkdir /mnt/data-store
sudo mount /dev/sdf /mnt/data-store
df -T
cd /mnt/data-store
sudo chmod 777.
echo "Hello World!" > helloworld.txt
