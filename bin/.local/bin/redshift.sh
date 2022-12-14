#!/bin/sh

source ~/.local/bin/env.sh 

envFile=~/.local/bin/env.sh 
changeValue=200

changeMode() {
  sed -i "s/REDSHIFT=$1/REDSHIFT=$2/g" $envFile 
  REDSHIFT=$2
  echo $REDSHIFT
}

changeTemp() {
  if [ "$2" -gt 1000 ] && [ "$2" -lt 25000 ]
  then
    sed -i "s/REDSHIFT_TEMP=$1/REDSHIFT_TEMP=$2/g" $envFile 
    redshift -P -O $((REDSHIFT_TEMP+changeValue))
  fi
}

case $1 in 
  toggle) 
    if [ "$REDSHIFT" = on ];
    then
      changeMode "$REDSHIFT" off
      redshift -x
    else
      changeMode "$REDSHIFT" on
      redshift -O "$REDSHIFT_TEMP"
    fi
    ;;
  state)
	if [ "$REDSHIFT" = on ]; then
		echo "on"
	else 
		echo "off"
    fi
    ;;
  increase)
	if [ "$REDSHIFT" = on ]; then
		changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP+changeValue))
    fi
    ;;
  decrease)
  	if [ "$REDSHIFT" = on ]; then
		changeTemp $((REDSHIFT_TEMP)) $((REDSHIFT_TEMP-changeValue));
	fi
    ;;
  temperature)
    case $REDSHIFT in
      on)
        printf " %dK" "$REDSHIFT_TEMP"
        ;;
      off)
        printf " Off"
        ;;
    esac
    ;;
esac
