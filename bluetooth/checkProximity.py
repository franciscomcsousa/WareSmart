homeDir = "/home/framboesa/SmartStorage/AmbientIntelligence/backend/"

def rssiToDistance(rssi):    
    n = 2
    mp = -69
    return round(10 ** ((mp - (int(rssi)))/(10 * n)),2)

def is_device_near():
    file = open(f"{homeDir}bluetooth/rssi.txt", 'r')
    lines = file.readlines()

    if (len(lines) < 2):
        return False
    
    # Find if the line has an RSSI value (means that device MIGHT be really near)
    position = lines[-2].find("RSSI: ")

    # Didn't find RSSI value
    if position == -1:
        return False
    
    # Starting position of the rssi value in string
    rssiPosition = position + len("RSSI: ")

    rssi = int(lines[-2][rssiPosition:])

    if(rssiToDistance(rssi) < 0.5):
        return True
    else:
        return False
