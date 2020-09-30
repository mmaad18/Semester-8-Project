#from serial import Serial
import serial, time, csv

#with serial.Serial('/dev/cu.usbmodem141201', 9600, timeout=1) as ser:

arduino = serial.Serial('/dev/cu.usbmodem141201', 9600, timeout=.1)

time.sleep(1) #give the connection time to settle

arduino.write(b'x0z10\n')


setpointState = False
with open('data_j2_10_4.csv', mode='w') as datalog_file:
    data_writer = csv.writer(datalog_file, delimiter=';')
    while True:
        data = arduino.readline()

        if data: 
            strip_data = data.rstrip('\r\n')
            
            split_data = strip_data.split(' ')

            if (len(split_data) == 18):
            
                if (split_data[0] == 'Joint1Set:'):
                    setpointState = True

                if (setpointState == True):
                    
                    #print(len(split_data))
                    j1angle = split_data[2]
                    j2angle = split_data[9]
                    timestamp = split_data[17]

                    data_writer.writerow([j1angle, j2angle, timestamp])

                    print(j1angle, j2angle, timestamp)