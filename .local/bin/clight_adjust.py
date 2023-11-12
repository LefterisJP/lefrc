#!/usr/bin/env python3

import dbus
import sys

bus = dbus.SessionBus()
obj = bus.get_object('org.clight.clight','/org/clight/clight')

step_value = 0.1
if sys.argv[1] == '-inc':
	obj.IncBl(float(step_value),dbus_interface='org.clight.clight')
if sys.argv[1] == '-dec':
	obj.DecBl(float(step_value),dbus_interface='org.clight.clight')
if sys.argv[1] == '-toggle':
    obj = bus.get_object('org.clight.clight','/org/clight/clight/Conf/Backlight')
    currVal = obj.Get('org.clight.clight.Conf.Backlight','NoAutoCalib',dbus_interface='org.freedesktop.DBus.Properties')
    obj.Set('org.clight.clight.Conf.Backlight','NoAutoCalib',not currVal,dbus_interface='org.freedesktop.DBus.Properties')
