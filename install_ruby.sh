echo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:rael-gc/rvm

sudo apt-get update

echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc

reboot 

