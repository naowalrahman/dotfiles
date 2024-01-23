#!/bin/sh

BAT=$(acpi -b | awk '{print $4}' | tr -d ',')
CHR=$(acpi -b | awk '{print $3}') 

if [[ $CHR == 'Charging,' ]]; then
    STATE='CHR'    
else
    STATE='BAT'
fi

# Full and short texts
echo "Battery: $BAT ($STATE)"

# Set urgent flag below 5% or use orange below 20%
[ ${BAT%?} -le 5 ] && exit 33
[ ${BAT%?} -le 20 ] && echo "#FF8000"

exit 0
