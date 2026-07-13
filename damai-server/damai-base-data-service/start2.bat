@echo off
set SPRING_DATA_REDIS_PASSWORD=vcxz%%&356
java -XX:MaxMetaspaceSize=256M -Xmx512M -Dspring.data.redis.host=common-framework.com.cn -Dspring.cloud.nacos.discovery.server-addr=common-framework.com.cn:8848 -Dspring.kafka.bootstrap-servers=common-framework.com.cn:9092 -Delasticsearch.ip=common-framework.com.cn:9200 -Delasticsearch.userName=elastic -Delasticsearch.passWord=zxc321 -Dprefix.distinction.name=xlxa -jar damai-base-data-service-0.0.1-SNAPSHOT.jar
