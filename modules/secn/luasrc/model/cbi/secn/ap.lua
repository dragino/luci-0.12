--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Copyright 2013 Edwin Chen <edwin@dragino.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: ap.lua 5948 2010-03-27 14:54:06Z jow $
]]--

m = Map("secn", translate("Small Enterprise-Campus Network"))
s = m:section(NamedSection, "accesspoint", "secn", translate("Access Point"))
s.addremove = false

local ad = s:option(Flag, "ap_disable", translate("<abbr title=\"This option will be set Disable if select WiFi as WAN interface\">Enable WiFi AP</abbr>"),
	"Enable WiFi AP")
ad.enabled  = "0"
ad.disabled = "1"
ad.rmempty  = false

local ssid = s:option(Value, "ssid", "<abbr title=\"SSID, Leave blank to use hostname as default setting\">Station ID</abbr>")
ssid.default= luci.sys.hostname()
ssid.placeholder = "Default:" .. luci.sys.hostname()

local encry = s:option(ListValue, "encryption", "Encryption")
encry:value("mixed-psk+tkip+aes","WPA-WPA2-AES")
encry:value("mixed-psk","WPA-WPA2")
encry:value("psk","WPA")
encry:value("psk2","WPA2")
encry:value("wep","WEP")
encry:value("none","None")

local pwd = s:option(Value, "passphrase", "Passphrase")
pwd.default= "dragino-dragino"
pwd.placeholder = "AP Password"
pwd.password = true
pwd:depends("encryption","mixed-psk+tkip+aes")
pwd:depends("encryption","mixed-psk")
pwd:depends("encryption","psk")
pwd:depends("encryption","psk2")
pwd:depends("encryption","wep")



local channel = s:option(ListValue, "channel", "Channel")
channel.default = "6"
for i=1,11 do  
	channel:value(i,"Channel ".. i)
end
	channel:value("12","Channel 12")
	channel:value("13","Channel 13")

local ass = s:option(Value, "maxassoc", "AP Connections")
ass.default= "30"
ass.rmempty  = false
ass.datatype = "range(0,60)"
ass.placeholder = "a number from 0 to 60,0 means disable"

return m