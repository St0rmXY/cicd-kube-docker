FROM centos:latest
RUN yum -y update && \
    yum install -y epel-release && \
    yum install -y httpd zip unzip && \
    yum clean all
ADD https://www.free.css.com/assets/files/free.css.template/download/page254/photogenic.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip photogenic.zip
RUN cp -rvf photogenic/* .
RUN rm -rf photgenic photogenic.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 22