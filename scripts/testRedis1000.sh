

while true; do
    read -p "This will erase all database and create example one. yes or no ?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

redis-cli flushall

length=1000

for i in $(seq 0 $length )
do
	redis-cli HMSET ulas:dikme:$i time 12:34 date 03.05.2021 roomTemp 34 roomHum 80 firstName ulas$i secName dikme birthDate 03.06.1990 licenseNumber 1234 trackingId 12345 bodyTemprature 34 reflectivirt 12 heartRate 45 breathingRate 23 sp02 45 health 24 exposure 44 weight 78 height 180 age 30 sex male race tc mood happy posse sleep clothing shorts face mask photo 0
done


for i in $( seq 0 $length )
do
        redis-cli RPUSH epilog ulas:dikme:$i
done

