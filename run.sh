#Running the project

# docker-machine start bigdata
# docker-machine env bigdata
# eval $(docker-machine env bigdata)
./docker/local-setup.sh bigdata

source env/bin/activate
docker ps
cd kafka
# python fast-data-producer.py stock-analyzer 192.168.99.100:9092 &
export ENV_CONFIG_FILE=`pwd`/config/dev.cfg
python flask-data-producer.py &
cd ../
cd Spark
spark-submit --jars spark-streaming-kafka-0-8-assembly_2.11-2.0.0.jar stream-processing.py stock-analyzer average-stock-price 192.168.99.100:9092 &
cd ../
sleep 10s
cd Redis
python redis-publisher.py average-stock-price 192.168.99.100:9092 average-stock-price 192.168.99.100 6379 &
cd ../
# cd nodejs
# node showResult.js --port=3000 --redis_host=192.168.99.100 --redis_port=6379 --subscribe_topic=average-stock-price &
# node index.js --port=3000 --redis_host=192.168.99.100 --redis_port=6379 --subscribe_topic=average-stock-price
# cd ../
