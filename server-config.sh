sudo yum install git -y
#sudo yum install java-1.8.0-openjdk-devel -y
#sudo yum install maven -y
sudo yum install docker -y

sudo systemctl start docker

if [ -d "addressbook" ]
then
    echo "Repo is cloned and exists"
    cd /home/ec2-user/addressbook
    git pull origin master
else
    git clone https://github.com/Hirajis/addressbook.git
    cd addressbook
fi

#mvn package
sudo docker build -t $1:$2 /home/ec2-user/addressbook
#devopstrainer/java-mvn-privaterepos:1




