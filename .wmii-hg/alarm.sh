#!/bin/zsh

{
    echo $@ | wmiir create /lbar/alarm
    sleep 10
    wmiir remove /lbar/alarm &> /dev/null
} &
