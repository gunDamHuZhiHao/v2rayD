#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 7
#	Description: 一键部署v2ray
#	Version: 0.0.1a
#	Author: huZhiHao
#=================================================


#=====================初始化定义开始=====================

#获取启动脚本时的传参
domain=$1
name=$2
uuid=$3

## blue to echo 
function blue(){
    echo -e "\033[35m[ $1 ]\033[0m"
}

## Error to warning with blink
function bred(){
    echo -e "\033[31m\033[01m\033[05m[ $1 ]\033[0m"
}

## warning with blink
function byellow(){
    echo -e "\033[33m\033[01m\033[05m[ $1 ]\033[0m"
}

## Pass
function green(){
    echo -e "\033[32m[ $1 ]\033[0m"
}

## Error
function red(){
    echo -e "\033[31m\033[01m[ $1 ]\033[0m"
}

## warning
function yellow(){
    echo -e "\033[33m\033[01m[ $1 ]\033[0m"
}

#=====================初始化定义结束=====================


#=====================相关函数开始=====================

#安装docker服务
installDocker(){
	clear
	yellow "开始安装docker服务";
	##curl -fsSL https://get.docker.com -o get-docker.sh  && \
	##bash get-docker.sh
	yum update -y
    	yum install yum-utils device-mapper-persistent-data lvm2 -y
    	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    	yum install conntrack-tools -y
    	##yum install docker-ce-18.09.1 -y
	yum install --allowerasing docker-ce -y
	sleep 3s
	green "安装docker服务结束";
	sleep 3s
}

#启动docker
startDocker(){
	clear
	yellow "开始启动docker";
	systemctl start docker.service
	sleep 3s
	green "启动docker完成";
	sleep 3s
}

#docker开机自启
autoDocker(){
	clear
	yellow "设置docker开机自启";
	systemctl enable docker.service
	sleep 3s
	green "设置docker开机自启完成";
	sleep 3s
}

#下载启动容器
runV2rayContainer(){
	clear
	yellow "开始启动容器";
	sudo docker rm -f v2ray
	#sudo docker run -d --name v2ray -p 443:443 -p 80:80 -v $HOME/.caddy:/root/.caddy --restart=always huzhihao/v2ray_docker:0.0.1a $domain $name $uuid && sleep 3s && sudo docker logs  v2ray
	sudo docker run -d --name v2ray \
	  -p 443:443 \
	  -p 80:80 \
	  -v $HOME/.caddy:/root/.caddy \
	  -v /etc/v2ray:/etc/v2ray \
	  --restart=always \
	  huzhihao/v2ray_docker:0.0.1a \
	  $domain \
	  $name \
	  $uuid 
	sleep 3s 
	sudo docker logs v2ray
	sleep 3s
	green "容器启动完成";
	sleep 3s
}

#获取参数
initParam(){
	clear
	if  [ ! -n "$domain" ] ;then
		clear	
		read -t 30 -e -p "请输入解析到本ip的域名（默认www.domain.com）：" domain
		domain=${domain:-"www.domain.com"}
		# if [ -z "${domain}" ];then
		# 	domain="www.domain.com"
		# fi
	fi
	
	if  [ ! -n "$name" ] ;then
		clear
		read -t 30 -e -p "请输入服务器备注名称（默认V2RAY）：" name
		name=${name:-"V2RAY"}
		# if [ -z "${name}" ];then
		# 	name="V2RAY"
		# fi
	fi
	
	if  [ ! -n "$uuid" ] ;then
		clear
    		read -t 30 -e -p "请输入服务器UUID（建议默认 随机生成）：" uuid
	fi
}

#=====================相关函数结束=====================


#=====================执行步骤开始=====================

#开始部署
byellow "开始执行部署";

#获取参数
initParam

#安装docker服务
installDocker

#启动docker
autoDocker

#docker开机自启
startDocker

#下载启动容器
runV2rayContainer

#开始部署
byellow "部署完成";

#=====================执行步骤结束=====================
