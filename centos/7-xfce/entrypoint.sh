#!/bin/bash

echo Entrypoint script is Running

env_user=$USER
env_passwd=$PASSWORD
env_root=$ROOT

[ -z $env_user ] && echo "We need to get value of env_user" && exit 1
[ -z $env_passwd ] && echo "We need to get value of env_passwd" && exit 1
[ -z $env_root ] && echo "We need to get value of env_root" && exit 1

echo User is $env_user
echo Root mode is $env_root


check_user=$(cat /etc/passwd | grep $env_user)

if [ -z $check_user] 
then
	echo "We not found $env_user"
	useradd $env_user
	echo "Creating $env_user"
	sleep 1

	echo "Setting passwd about $env_user"
	echo $env_user:$env_passwd | chpasswd

	if [ $env_root == "yes" ]
	then
		usermod -aG wheel $env_user
	fi
fi

echo "We're Starting xrdp services"
xrdp-sesman && xrdp -n 
