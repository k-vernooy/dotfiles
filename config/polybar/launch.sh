#!/bin/bash

pkill polybar

polybar -r bump &
polybar -r main &
