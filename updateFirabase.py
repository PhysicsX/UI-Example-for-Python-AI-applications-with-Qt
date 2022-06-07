# python script to update firebase in time interval

import json  
import requests
import redis
import time
from datetime import datetime

from requests import ReadTimeout, ConnectTimeout, HTTPError, Timeout, ConnectionError

r = redis.Redis()


lastSave = 0
lastLen = -1

while True:
    data = {}
    dateLast = r.lastsave()
    #strSave = dateLast.strftime("%H:%M:%S")
    lenRedis = r.llen('epilog')
    print(lenRedis)

    lastInt = int(dateLast.timestamp())

    #print(lastInt," ",lastSave)
    if((lastInt!=lastSave) or (lenRedis!=lastLen)):
        
        print("updated")
        lastSave = lastInt
        lastLen = lenRedis
        listEpilog = r.lrange('epilog', 0, -1)

        for listElement in listEpilog:
            try:
                d = r.hgetall(listElement)
                keys_values = d.items()
                new_d = {key.decode("utf-8"): value.decode("utf-8") for key, value in keys_values}
            except IndexError:
                d = 'null'
                lastSave = 0
                continue
            data[listElement.decode("utf-8")] = new_d

        # Serializing json   
        json_object = json.dumps(data, indent = 4)  
        
        try:

            response = requests.put('https://example-72273-default-rtdb.europe-west1.firebasedatabase.app/epilog_database.json', json_object)

            #print(response.headers)
            if not response.headers:
                print('Check internet connection, json can not be updated')
        except requests.ConnectionError as e:
            print("OOPS!! Connection Error. Make sure you are connected to Internet. Technical Details given below.\n")
            print(str(e))            
            lastSave = 0
            continue
        except requests.Timeout as e:
            print("OOPS!! Timeout Error")
            print(str(e))
            lastSave = 0
            continue
        except requests.RequestException as e:
            print("OOPS!! General Error")
            print(str(e))
            lastSave = 0
            continue        
    time.sleep(5) # check every 5 seconds
