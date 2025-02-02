#!/bin/bash

cat $1 | grep -v ^\/home\/ | grep -v ^\/dev\/ | grep -v ^\/proc\/ | grep -v ^\/sys\/ | grep -v ^\/run\/ | grep -v ^\/tmp\/ | grep -v ^\/usr\/src\/ | grep -v ^\/var\/db\/ | grep -v ^\/var\/tmp\/ | grep -v ^\/root\/ | grep -v ^\/var\/cache\/distfiles\/ > $2
