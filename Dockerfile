FROM almalinux:8
RUN yum -y update && \
    yum install -y epel-release && \
    yum install -y httpd zip unzip && \
    yum clean all
ADD https://www.tooplate.com/zip-templates/2137_barista_cafe.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip 2137_barista_cafe.zip
RUN cp -rvf 2137_barista_cafe/* .
RUN rm -rf 2137_barista_cafe 2137_barista_cafe.zip
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
EXPOSE 80 22