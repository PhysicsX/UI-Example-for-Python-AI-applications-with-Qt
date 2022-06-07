

while true; do
    read -p "This will erase all database and create example one. yes or no ?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

redis-cli flushall

redis-cli RPUSH epilog ulas:dikme:30 fredy:mercury:40 martha:lumen:28 nettie:autumn:29 mabelle:rosalyn:41 robin:algernon:32 daphne:kelley:21 penelope:brandt:45 jaron:emilia:35 katriona:garth:15 

redis-cli HMSET ulas:dikme:30 time 12:34 date 03.05.2021 roomTemp 34 roomHum 80 firstName ulas secName dikme birthDate 03.06.1990 licenseNumber 1234 trackingId 12345 bodyTemprature 37 reflectivirt 12 heartRate 45 breathingRate 23 sp02 95 health 24 exposure 44 weight 78 height 180 age 30 sex male race tc mood happy posse sleep clothing shorts face mask photo 0

redis-cli HMSET fredy:mercury:40 time 12:36 date 03.05.2021 roomTemp 32 roomHum 78 firstName fredy secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 38 reflectivirt 35 heartRate 145 breathingRate 23 sp02 92 health 30 exposure 64 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 1

redis-cli HMSET martha:lumen:28 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 39 reflectivirt 89 heartRate 200 breathingRate 23 sp02 94 health 67 exposure 24 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 2

redis-cli HMSET nettie:autumn:29 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 41 reflectivirt 67 heartRate 180 breathingRate 23 sp02 96 health 86 exposure 74 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 3

redis-cli HMSET mabelle:rosalyn:41 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 35 reflectivirt 63 heartRate 110 breathingRate 23 sp02 98 health 97 exposure 84 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 4

redis-cli HMSET robin:algernon:32 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 36 reflectivirt 99 heartRate 45 breathingRate 23 sp02 100 health 12 exposure 94 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 5

redis-cli HMSET daphne:kelley:21 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 38 reflectivirt 84 heartRate 45 breathingRate 23 sp02 96 health 64 exposure 14 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 6

redis-cli HMSET penelope:brandt:45 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 38 reflectivirt 35 heartRate 45 breathingRate 23 sp02 96 health 44 exposure 57 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 7

redis-cli HMSET jaron:emilia:35 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 38 reflectivirt 66 heartRate 45 breathingRate 23 sp02 97 health 24 exposure 23 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 8

redis-cli HMSET katriona:garth:15 time 05:26 date 13.05.2021 roomTemp 38 roomHum 28 firstName martha secName mercury birthDate 23.05.1975 licenseNumber 1334 trackingId 12345 bodyTemprature 38 reflectivirt 72 heartRate 45 breathingRate 23 sp02 94 health 24 exposure 64 weight 78 height 165 age 33 sex male race tc mood happy pose sleep clothing shorts face mask photo 9
