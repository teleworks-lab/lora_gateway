#!/bin/sh

# This script is intended to be used on Teleworks IoT board, it performs
# LDO and Reset Pin on Teleworks IoT board is controled by this script 
#  
# refer to 
#        - teleworks.sch 
#
# Usage examples:
#       ./setup_lgw.sh enable
#       ./setup_lgw.sh disable


VER=1.6

SX1301_EN=119
SX1301_RESET=114

FPGA_EN=118

LTE_PWR=160
LTE_EN=161

GPS_EN=117
GPS_RESET=116

WAIT_GPIO_100MS() {
    sleep 0.1
}

WAIT_GPIO_10MS() {
    sleep 0.01
}

iot_gpio_enable() { 
     
    # setup GPIO
    echo "$SX1301_EN" > /sys/class/gpio/export; WAIT_GPIO_10MS 
    echo "$SX1301_RESET" > /sys/class/gpio/export
    echo "Setup SX1301_EN / SX1301_RESET "   
    
    echo "$FPGA_EN" > /sys/class/gpio/export
    echo "Setup FPGA_EN "   

    echo "$LTE_EN" > /sys/class/gpio/export; WAIT_GPIO_10MS
    echo "$LTE_PWR" > /sys/class/gpio/export
    echo "Setup LTE_EN / LTE_PWR " 

    echo "$GPS_EN" > /sys/class/gpio/export; WAIT_GPIO_10MS
    echo "$GPS_RESET" > /sys/class/gpio/export    
    echo "Setup GPS_EN / GPS_RESET "     

    # set GPIO  as output
    echo "out" > /sys/class/gpio/gpio$SX1301_EN/direction
    echo "out" > /sys/class/gpio/gpio$SX1301_RESET/direction

    echo "out" > /sys/class/gpio/gpio$FPGA_EN/direction

    echo "out" > /sys/class/gpio/gpio$LTE_EN/direction
    echo "out" > /sys/class/gpio/gpio$LTE_PWR/direction

    echo "out" > /sys/class/gpio/gpio$GPS_EN/direction
    echo "out" > /sys/class/gpio/gpio$GPS_RESET/direction;WAIT_GPIO_100MS

    echo "Set GPIO about as Output "  
}

iot_gpio_disable() { 
     
    if [ -d /sys/class/gpio/gpio$SX1301_EN ];then     
        echo "$SX1301_EN" > /sys/class/gpio/unexport
        echo "OK, Disable SX1301_EN Pin"
    else
        echo "Failed, Disable SX1301_EN Pin"
    fi    
    
    if [ -d /sys/class/gpio/gpio$SX1301_RESET ];then     
        echo "$SX1301_RESET" > /sys/class/gpio/unexport
        echo "OK, Disable SX1301_RESET Pin"    
    else
        echo "Failed, Disable SX1301_RESET Pin"        
    fi       

    if [ -d /sys/class/gpio/gpio$FPGA_EN ];then     
        echo "$FPGA_EN" > /sys/class/gpio/unexport
        echo "OK, Disable FPGA_EN Pin"
    else
        echo "Failed, Disable FPGA_EN Pin"           
    fi   

    if [ -d /sys/class/gpio/gpio$LTE_EN ];then     
        echo "$LTE_EN" > /sys/class/gpio/unexport
        echo "OK, Disable LTE_EN Pin"
    else
        echo "Failed, Disable LTE_EN Pin"          
    fi   
  
    if [ -d /sys/class/gpio/gpio$LTE_PWR ];then     
        echo "$LTE_PWR" > /sys/class/gpio/unexport
        echo "OK, Disable LTE_PWR Pin"
    else
        echo "Failed, Disable LTE_PWR Pin"           
    fi   

    if [ -d /sys/class/gpio/gpio$GPS_EN ];then     
        echo "$GPS_EN" > /sys/class/gpio/unexport
        echo "OK, Disable GPS_EN Pin"
    else
        echo "Failed, Disable GPS_EN Pin"            
    fi   

    if [ -d /sys/class/gpio/gpio$GPS_RESET ]; then     
        echo "$GPS_RESET" > /sys/class/gpio/unexport
        echo "OK, Disable GPS_RESET Pin"
    else
        echo "Failed, Disable GPS_RESET Pin"          
    fi   

}

case "$1" in
    enable)
    echo  ">> Start  Setup LDO and Reset Ver.$VER (Teleworks)"
    iot_gpio_enable
    echo  ">> Finish Setup LDO and Reset Ver.$VER (Teleworks)"
    ;;
    disable)
    echo ">> Start  Setup LDO and Reset Ver.$VER (Teleworks)"
    iot_gpio_disable
    echo ">> Finish Setup LDO and Reset Ver.$VER (Teleworks)"
    ;;
    *)
    echo "Usage: $0 {enable|disable}"
    exit 1
    ;;
esac

exit 0
