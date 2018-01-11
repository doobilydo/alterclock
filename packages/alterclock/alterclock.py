#!/usr/bin/python
import time;

interval_second = 0
interval_minute = 0

'''
Actual seconds.
Sh
'''
def getRealSecond():
  return time.localtime(time.time()).tm_sec

'''
Actual minutes.
Mh
'''
def getRealMinute():
  return time.localtime(time.time()).tm_min

'''
Actual hour
Hh
'''
def getRealHour():
  return time.localtime(time.time()).tm_hour

'''
Actual minutes in terms of seconds.
'''
def getMs():
  return getRealMinute() * 60

'''
Interval second as integer.
'''
def getSi():
  return (getMs() + getRealSecond()) % 36

'''
Interval minute as integer.
'''
def getMi():
  return (getMs() + getRealSecond()) / 36
  


'''
Run.
'''
def main():
#
#Hi:Mi:Si
#Hh:Mh:Sh
#
  global interval_second
  global interval_minute
  interval_second = getSi()
  interval_minute = getMi()

  while True:
    
    print "\n" * 100
    #print "%02d:%02d:%02d - Interval time" % (getRealHour(), interval_minute, interval_second)
    print "%02d:%02d:%02d - Real time" % (getRealHour(), getRealMinute(), getRealSecond())
    print "%02d:%02d:%02d - Interval time" % (getRealHour(), getMi(), getSi())
    #interval_second += 1

    #if interval_second == 36:
    #  interval_minute += 1
    #  interval_second = 0

    #if interval_minute == 100:
    #  interval_minute = 0
    
    time.sleep(1)
  
        

main()
