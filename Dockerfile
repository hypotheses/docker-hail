FROM openjdk:8u131-jdk-alpine
MAINTAINER Shane Husson shane.a.husson@gmail.com

RUN apk add --update \
    bash \
    cmake \
    curl \
    g++ \
    git \
    gzip \
    make \
    libc6-compat \
    tar

ENV SPARK_HOME=/usr/spark/spark-2.1.0-bin-hadoop2.7 \
    HAIL_HOME=/usr/hail \
    PATH=$PATH:/usr/spark/spark-2.1.0-bin-hadoop2.7/bin:/usr/hail/bin/ \
    PYTHONPATH="$PYTHONPATH:$HAIL_HOME/python:$SPARK_HOME/python:`echo $SPARK_HOME/python/lib/py4j*-src.zip`" \
    SPARK_CLASSPATH=$HAIL_HOME/build/libs/hail-all-spark.jar

RUN mkdir /usr/spark && \
    curl -sL --retry 3 \
    "https://archive.apache.org/dist/spark/spark-2.1.0/spark-2.1.0-bin-hadoop2.7.tgz" \
    | gzip -d \
    | tar x -C /usr/spark && \
    chown -R root:root $SPARK_HOME

RUN mkdir /usr/hail && cd ${HAIL_HOME} && \
    wget https://storage.googleapis.com/hail-common/distributions/0.1/Hail-0.1-2372f0ee9d52-Spark-2.1.0.zip && \
    unzip Hail-0.1-2372f0ee9d52-Spark-2.1.0.zip

RUN apk add python py-pip python-dev && \
    pip install jupyter pyspark

ENTRYPOINT ["hail"]
CMD ["-h"]
