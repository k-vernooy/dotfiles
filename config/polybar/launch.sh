#!/bin/bash

pkill polybar

polybar -r main &
polybar -r bump &
