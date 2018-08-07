# listen to a power-button on GPIO 22 
# based on:
# https://howchoo.com/g/mwnlytk3zmm/how-to-add-a-power-button-to-your-raspberry-pi
# adjusted to GPIO 22 due to already using I2C
import RPi.GPIO as GPIO
import subprocess
import time

def shutdown_request(channel):
    print ("Starting countign seconds..")
    if (not GPIO.input(channel)):
        #print str(datetime.datetime.now()), " Shutdown request"
        #sys.stdout.flush()
        #os.system('/sbin/shutdown -h now')
        x = 0
        for i in range(5):
            if (not GPIO.input(channel)):
                x = x + 1
            print (x)
            sleep(1)
        if x == 5:
            print('Power Down')
            subprocess.call(['shutdown', '-h', 'now'], shell=False)


GPIO.setmode(GPIO.BCM)
GPIO.setup(22, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.add_event_detect(22, GPIO.FALLING, callback=shutdown_request, bouncetime=5000)
print('Started listening for shutdown requests.')
while True:
    time.sleep(1)
#GPIO.wait_for_edge(22, GPIO.FALLING)
#print('Power Down')
#subprocess.call(['shutdown', '-h', 'now'], shell=False)
