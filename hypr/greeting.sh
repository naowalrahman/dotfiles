TIME=$(date "+%H")
if [ $TIME -lt 12 ]; then
    echo "Good morning, Naowal"
elif [ $TIME -lt 18 ]; then
    echo "Good afternoon, Naowal"
else
    echo "Good evening, Naowal"
fi
