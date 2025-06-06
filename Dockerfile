FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HADOOP_VERSION=3.3.6
ENV SPARK_VERSION=3.5.6
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64
ENV HADOOP_HOME=/opt/hadoop
ENV SPARK_HOME=/opt/spark
ENV PATH="$HADOOP_HOME/bin:$SPARK_HOME/bin:$JAVA_HOME/bin:$PATH"

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        python3 \
        python3-pip \
        openjdk-11-jdk \
        wget \
        curl \
        ssh \
        rsync \
        net-tools \
        iputils-ping \
        nano && \
    rm -rf /var/lib/apt/lists/*

# Install Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz

# Install Spark
RUN wget https://downloads.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Copy Hadoop and Spark config files
COPY config/hadoop/* $HADOOP_HOME/etc/hadoop/
COPY config/spark/spark-defaults.conf $SPARK_HOME/conf/
# Set JAVA_HOME in hadoop-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
# Copy startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set entrypoint
CMD ["/usr/local/bin/startup.sh"]
