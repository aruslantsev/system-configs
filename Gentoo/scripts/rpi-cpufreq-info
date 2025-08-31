#!/bin/bash
Counter=14
DisplayHeader="Time       Temp     CPU     Core         Health           Vcore    PMIC"
while true ; do
  let ++Counter
  if [ ${Counter} -eq 15 ]; then
        echo -e "${DisplayHeader}"
        Counter=0
  fi
  Health=$(perl -e "printf \"%19b\n\", $(vcgencmd get_throttled | cut -f2 -d=)")
  Temp=$(vcgencmd measure_temp | cut -f2 -d=)
  Pmic=$(vcgencmd measure_temp pmic | cut -f2 -d=)
  Clockspeed=$(vcgencmd measure_clock arm | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
  Corespeed=$(vcgencmd measure_clock core | awk -F"=" '{printf ("%0.0f",$2/1000000); }' )
  CoreVolt=$(vcgencmd measure_volts | cut -f2 -d= | sed 's/000//')
  echo -e "$(date '+%H:%M:%S')  ${Temp}  $(printf '%4s' ${Clockspeed})MHz $(printf '%4s' ${Corespeed})MHz  $(printf '%020u' ${Health})  ${CoreVolt}  ${Pmic}"
  sleep 10
done
