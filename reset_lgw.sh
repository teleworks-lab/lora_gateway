#!/bin/sh

# This script is intended to be used on IoT Starter Kit platform, it performs
# the following actions:
#       - export/unpexort GPIO7 used to reset the SX1301 chip
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start



VER=1.6

SX1301_EN=119
SX1301_RESET=114

LTE_PWR=160
LTE_EN=161

GPS_EN=117
GPS_RESET=116

FPGA_EN=118



WAIT_GPIO() {
    sleep 0.1
}

iot_sk_en() {

    # echo "Control GPIO SX1301_EN"
    echo "SX1301_EN out 0->1  in GPIO $SX1301_EN..."

    # setup GPIO 
    #echo "$SX1301_EN" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO  as output
    # echo "out" > /sys/class/gpio/gpio$SX1301_EN/direction; WAIT_GPIO

    # write output 
    echo "0" > /sys/class/gpio/gpio$SX1301_EN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$SX1301_EN/value
}

iot_sk_init() {

    # echo "Control GPIO RESET_SX1301"
    echo "SX1301_RESET out 1->0 in GPIO $SX1301_RESET..."
    # setup GPIO 7
    #echo "$SX1301_RESET" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO 7 as output
    #echo "out" > /sys/class/gpio/gpio$SX1301_RESET/direction; WAIT_GPIO

    # write output for SX1301 reset
    echo "1" > /sys/class/gpio/gpio$SX1301_RESET/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$SX1301_RESET/value

    # set GPIO 7 as input
    # echo "in" > /sys/class/gpio/gpio$SX1301_RESET/direction; WAIT_GPIO
}


iot_fpga_en() {

    # echo "Control GPIO FPGA_EN"
    echo "FPGA_EN out 0->1 in GPIO $FPGA_EN..."

    # setup GPIO
    # echo "$FPGA_EN" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO  as output
    # echo "out" > /sys/class/gpio/gpio$FPGA_EN/direction; WAIT_GPIO

    # write output
    echo "1" > /sys/class/gpio/gpio$FPGA_EN/value
}

iot_lte_en() {

    # echo "Control GPIO LTE_PWR/LTE_EN"
    echo "LTE_EN (LDO_ON)  out 0->1 in GPIO $LTE_EN..."
    echo "LTE_PWR(PWR_ON)  out 1    in GPIO $LTE_PWR..."

    # setup GPIO
    # echo "$LTE_EN" > /sys/class/gpio/export; WAIT_GPIO
    # echo "$LTE_PWR" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO  as output
    # echo "out" > /sys/class/gpio/gpio$LTE_EN/direction; WAIT_GPIO
    # echo "out" > /sys/class/gpio/gpio$LTE_PWR/direction; WAIT_GPIO

    # write output
    echo "0" > /sys/class/gpio/gpio$LTE_EN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$LTE_EN/value

    # Reset
    #echo "0" > /sys/class/gpio/gpio$LTE_PWR/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$LTE_PWR/value
    #echo "0" > /sys/class/gpio/gpio$LTE_PWR/value; WAIT_GPIO
}

iot_gps_en() {

    #echo "Control GPIO GPS_EN / GPS_RESET "
    echo "GPS_EN    out  0->1     in GPIO $GPS_EN..."
    echo "GPS_RESET out  1->0->1  in GPIO $GPS_RESET..."

    # setup GPIO
    # echo "$GPS_EN" > /sys/class/gpio/export; WAIT_GPIO
    # echo "$GPS_RESET" > /sys/class/gpio/export; WAIT_GPIO

    # set GPIO  as output
    # echo "out" > /sys/class/gpio/gpio$GPS_EN/direction; WAIT_GPIO
    # echo "out" > /sys/class/gpio/gpio$GPS_RESET/direction; WAIT_GPIO

    # write output
    echo "0" > /sys/class/gpio/gpio$GPS_EN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$GPS_EN/value
    
    # Reset Low Active 
    echo "1" > /sys/class/gpio/gpio$GPS_RESET/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$GPS_RESET/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$GPS_RESET/value

}



case "$1" in
    start)
    echo ">> Start Setting LDO and Reset Ver.$VER (Teleworks)" 
    iot_sk_en
    iot_sk_init
    iot_fpga_en
    iot_lte_en
    iot_gps_en
    echo ">> End  Setting  LDO and Reset Ver.$VER (Teleworks)"
    ;;
    stop)    
    ;;
    *)
    echo "Usage: $0 {start|stop} "
    exit 1
    ;;
esac

exit 0
