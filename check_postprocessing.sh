#!/usr/bin/env bash

# Checks output from ece-postprocess script
# and prints any files that are not found but
# should be there

var=0
for yr in $(seq 1979 2015); do
  for mnth in {01..12}; do
    var=$((var+1))
    if [ ! -f ${1}/ECE_${1}_${yr}${mnth}.nc ]; then
      fn=${1}/ECE_${1}_${yr}${mnth}.nc
      echo "not found:" ${fn} ${var}
    fi
    if [ ! -f ${1}/AMET_EC-earth_model_daily_${1}_${yr}${mnth}_E_point.nc ]; then
      fn=${1}/AMET_EC-earth_model_daily_${1}_${yr}${mnth}_E_point.nc
      echo "not found:" ${fn} ${var}
    fi
    if [ ! -f ${1}/AMET_EC-earth_model_daily_${1}_${yr}${mnth}_E_zonal_int.nc ]; then
      fn=${1}/AMET_EC-earth_model_daily_${1}_${yr}${mnth}_E_zonal_int.nc
      echo "not found:" ${fn} ${var}
    fi
  done
done

