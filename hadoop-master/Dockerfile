FROM mahmoudelgamal/spark-base:latest

MAINTAINER KiwenLau <kiwenlau@gmail.com>

#Install Git

ENV SPARK_CONF_HOME $SPARK_HOME/conf

RUN apt-get -y install git
RUN mkdir /usr/local/hue
RUN git clone https://github.com/cloudera/hue.git /usr/local/hue
#RUN cd /usr/local/hue/apps/spark/java/
RUN mvn -X -DskipTests -Dspark.version=1.6.0 -f /usr/local/hue/apps/spark/java/pom.xml clean package
#RUN ./usr/local/hue/apps/spark/java/bin/livy-server
#RUN cd -

# prepare
RUN cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh

# move all confugration files into container
ADD files/* /tmp/


#Install spark-job-rest
#RUN mv /tmp/start_server.sh /opt/spark-job-rest/spark-job-rest/src/main/scripts/start_server.sh
#RUN make build -C /opt/spark-job-rest/
#RUN make deploy -C /opt/spark-job-rest/
#RUN mv /tmp/application.conf /opt/spark-job-rest/deploy/resources/application.conf
#RUN make start -C /opt/spark-job-rest/

# install livy


ENV HADOOP_INSTALL /usr/local/hadoop

RUN mkdir -p ~/hdfs/namenode && \
mkdir -p ~/hdfs/datanode && \
mkdir $HADOOP_INSTALL/logs

RUN mv /tmp/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml && \
mv /tmp/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml && \
mv /tmp/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml && \
mv /tmp/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml && \
mv /tmp/slaves $HADOOP_INSTALL/etc/hadoop/slaves && \
mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh

RUN chmod +x ~/start-hadoop.sh && \
chmod +x ~/run-wordcount.sh && \
chmod +x ~/start-ssh-serf.sh && \
chmod 1777 tmp

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060

CMD '/root/start-ssh-serf.sh'; 'bash'
