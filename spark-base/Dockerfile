FROM kiwenlau/hadoop-base:0.1.0

MAINTAINER MahmoudElgamal <mahmoudf.elgamal@gmail.com>


ENV HADOOP_PREFIX /usr/local/hadoop
#support for Hadoop 2.3.0

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.3.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.6.0-bin-hadoop2.3 spark
ENV SPARK_HOME /usr/local/spark
RUN cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties
#RUN mkdir $SPARK_HOME/yarn-remote-client
#ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

#RUN $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-1.6.0-bin-hadoop2.3/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
#COPY bootstrap.sh /etc/bootstrap.sh
#RUN chown root.root /etc/bootstrap.sh
#RUN chmod 700 /etc/bootstrap.sh


RUN apt-get update
RUN apt-get -y install build-essential
RUN apt-get -y install maven


#ENTRYPOINT ["/etc/bootstrap.sh"]

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122
