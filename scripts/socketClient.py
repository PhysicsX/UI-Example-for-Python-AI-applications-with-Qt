import socket
import sys
from datetime import datetime

# Create a UDS socket
sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = '/tmp/socketEbt'

try:
    sock.connect(server_address)
except socket.error as msg:
    print(msg.errno)
    sys.exit(1)
    
try:
    # Send data
    my_str = "ulasdikme asd"
    my_str_as_bytes = str.encode(my_str)
    lenrr = len(my_str)
    print(lenrr)
    lenrr = lenrr.to_bytes(1, byteorder='big')

    print(lenrr)

    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    fileToSave = now.strftime("%H_%M_%S")
    print(type(current_time))
    today = datetime.today()
    day = today.strftime("%d.%m.%Y")
    dayFile = today.strftime("%d_%m_%Y")

    payload = len(current_time).to_bytes(1, byteorder='big') + str.encode(current_time) + len(day).to_bytes(1, byteorder='big') + str.encode(day)
    payload = payload + (28).to_bytes(1, byteorder='big') #roomTemp
    payload = payload + (78).to_bytes(1, byteorder='big') #roomHum
    payload = payload + len("ulas").to_bytes(1, byteorder='big') +str.encode("ulas") # first name
    payload = payload + len("dikme").to_bytes(1, byteorder='big') +str.encode("dikme") # sec name
    payload = payload + len("23.05.1975").to_bytes(1, byteorder='big') + str.encode("23.05.1975") # birth date
    payload = payload + (1234).to_bytes(2, byteorder='big') # lincese number
    payload = payload + (1234).to_bytes(2, byteorder='big') # trackingId
    payload = payload + (37).to_bytes(1, byteorder='big') # bodyTemprature
    payload = payload + (67).to_bytes(1, byteorder='big') # reflectivirt
    payload = payload + (180).to_bytes(1, byteorder='big') # heartRate
    payload = payload + (23).to_bytes(1, byteorder='big') # breathingRate
    payload = payload + (96).to_bytes(1, byteorder='big') # sp02
    payload = payload + (86).to_bytes(1, byteorder='big') # health
    payload = payload + (74).to_bytes(1, byteorder='big') # exposure
    payload = payload + (78).to_bytes(1, byteorder='big') # weight
    payload = payload + (165).to_bytes(1, byteorder='big') # height
    payload = payload + (33).to_bytes(1, byteorder='big') # age    
    payload = payload + len("male").to_bytes(1, byteorder='big') +str.encode("male") # sex
    payload = payload + len("tc").to_bytes(1, byteorder='big') +str.encode("tc") # race                    
    payload = payload + len("happy").to_bytes(1, byteorder='big') +str.encode("happy") # mode    
    payload = payload + len("sleep").to_bytes(1, byteorder='big') +str.encode("sleep") # pose
    payload = payload + len("shorts").to_bytes(1, byteorder='big') +str.encode("shorts") # clothing
    payload = payload + len("mask").to_bytes(1, byteorder='big') +str.encode("mask") # face
    payload = payload + len(dayFile+"_"+fileToSave).to_bytes(1, byteorder='big') +str.encode(dayFile+"_"+fileToSave) # photo path

    #payload = lenrr + my_str_as_bytes  + len(current_time).to_bytes(1, byteorder='big') + str.encode(current_time) 
    
    sock.sendall(payload)
    
    # amount_received = 0
    # amount_expected = len(message)
    
    # while amount_received < amount_expected:
    #     data = sock.recv(16)
    #     amount_received += len(data)
    #     print >>sys.stderr, 'received "%s"' % data

finally:
    print(sys.stderr, 'closing socket')
    sock.close()