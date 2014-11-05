FROM debian:wheezy

MAINTAINER WilliamWolface <william@wolface.com>

COPY JOIN/run /usr/local/bin/run
COPY JOIN/nothing /usr/local/bin/nothing

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q wget

# Récupération de ZendServer
RUN wget -P $HOME http://downloads.zend.com/zendserver/7.0.0/ZendServer-7.0.0-RepositoryInstaller-linux.tar.gz;
RUN tar -xzvf $HOME/ZendServer-7.0.0-RepositoryInstaller-linux.tar.gz;
RUN sudo sh $HOME/ZendServer-RepositoryInstaller-linux/install_zs.sh 5.5 nginx;

EXPOSE 80
EXPOSE 443
EXPOSE 10081
EXPOSE 10082
EXPOSE 10060
EXPOSE 10061
EXPOSE 10062

CMD ["/usr/local/bin/run"]