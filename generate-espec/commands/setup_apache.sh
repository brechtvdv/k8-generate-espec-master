apt-get update
apt-get install -y apache2 dstat
dd if=/dev/zero of=/var/www/html/1KB.txt count=1 bs=1024
dd if=/dev/zero of=/var/www/html/10KB.txt count=10 bs=1024
dd if=/dev/zero of=/var/www/html/50KB.txt count=50 bs=1024
dd if=/dev/zero of=/var/www/html/100KB.txt count=100 bs=1024
dd if=/dev/zero of=/var/www/html/1MB.txt count=1024 bs=1024
