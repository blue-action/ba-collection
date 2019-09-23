#!/usr/bin/env bash

# Usage
# Run in output directory
#
# fix_daily.sh expname

# version suffix
suff="v2"

# start and end year
start_year=1979
end_year=2015

# filename definitions
basename="ECE"
expname=$1  # experiment name

# ECE_O2Q7_SSHF_daily_2010.nc

# ECE_O2Q7_T2M_daily_2010.nc
# ECE_O2Q7_T_daily_2010.nc
# ECE_O2Q7_U_daily_2010.nc
# ECE_O2Q7_V_daily_2010.nc
# ECE_O2Q7_Z_daily_2010.nc
# ECE_O2Q7_MSL_daily_2010.nc

# add scale factor to daily instantaneous vars 
# we summed three hourly fields, per day
# divide by 4 to get daily
fixVars="T2M T U V Z MSL"
for var in ${fixVars}; do
  for yr in $(seq ${start_year} ${end_year}); do
    infile="${basename}_${expname}_${var}_daily_${yr}.nc"
    outfile="${basename}_${expname}_${var}_daily_${yr}_${suff}.nc"
    if [ -f ${infile} ]; then
      ncatted -a scale_factor,${var},c,f,0.25 "${infile}"
      mv "${infile}" "${outfile}"
      echo "DONE ${outfile}"
    else
      echo "ERROR [file missing] ${outfile}"
    fi
  done
done

# add scale factor to daily fluxes
# we summed three hourly fields, per day
# divide by 4 to get daily average of 3 hourly fields
# then by 3 * 60 * 60 to get W/m2
fixVars="SSHF"
for var in ${fixVars}; do
  for yr in $(seq ${start_year} ${end_year}); do
    infile="${basename}_${expname}_${var}_daily_${yr}.nc"
    outfile="${basename}_${expname}_${var}_daily_${yr}_${suff}.nc"
    if [ -f ${infile} ]; then
      ncatted -a scale_factor,${var},c,f,2.314814814814814e-5 "${infile}"
      ncatted -a units,${var},o,c,"W m**-2" "${infile}"
      mv "${infile}" "${outfile}"
      echo "DONE ${outfile}"
    else
      echo "ERROR [file missing] ${outfile}"
    fi
  done
done
