#!/usr/bin/env bash

cat /proc/loadavg | cut -d " " -f 1-3
