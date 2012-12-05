#!/bin/bash
echo `gtf $1 $1 60 | grep Modeline | sed s/Modeline\ // | tr -d '"'`
