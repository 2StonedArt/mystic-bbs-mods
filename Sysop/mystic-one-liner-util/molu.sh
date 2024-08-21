#!/bin/bash
# Utility Build
fpc -vq -g -gl -gw2 MysticOLUtil.pas -Fu../RMDoor -Fu* | grep -v 'generics.collections.pas'
