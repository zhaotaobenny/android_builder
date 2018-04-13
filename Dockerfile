# Create Common Android Build Enviroment

FROM ubuntu:14.04

MAINTAINER Benny.Zhao zhaotao1985@163.com

RUN set -ex \
 && \
 { \
   echo "en_US.UTF-8 UTF-8"; \
   echo "zh_CN.UTF-8 UTF-8"; \
   echo "zh_CN.GBK GBK"; \
   echo "zh_CN GB2312"; \
 } > /var/lib/locales/supported.d/local \
 && \
 { \
   echo "LANG=\"en_US.UTF-8\""; \
   echo "LANGUAGE=\"en_US:en\""; \
   echo "LC_ALL=\"C\""; \
 } > /etc/default/locale \
 && cd /etc && unlink localtime && ln -s /usr/share/zoneinfo/PRC localtime \
 && echo "PRC" > /etc/timezone \
 && locale-gen

RUN set -ex \
 && apt-get update \
 && apt-get install -y software-properties-common python-software-properties \
 && add-apt-repository -y ppa:openjdk-r/ppa \
 && apt-get update \
 && apt-get -y install gcc g++ git gnupg flex bison gperf dpkg-dev gcc-multilib build-essential lftp p7zip-full \
                       zip curl libc6-dev x11proto-core-dev libgl1-mesa-dev g++-multilib mingw32 tofrodos bc jq \
                       openssh-server python-markdown libxml2-utils xsltproc openjdk-7-jdk openjdk-8-jdk libssl-dev \
                       libncurses5-dev libx11-dev libreadline6-dev libgl1-mesa-glx zlib1g-dev \
 && apt-get clean && apt-get autoclean \
 && rm -rf /tmp/* /var/cache/* /var/log/* /var/lib/apt/lists/*
 
RUN set -ex \
 && cd /tmp && git clone https://github.com/zhaotaobenny/repo.git \
 && cp -f /tmp/repo/repo /usr/bin/ \
 && rm -rf /tmp/repo
 
RUN set -ex \
 && echo "builder    ALL=(ALL:ALL) ALL" >> /etc/sudoers \
 && useradd builder -m -d /home/builder -m -p \!\@\#builder\$\%\^
 
USER builder

WORKDIR /home/builder
 