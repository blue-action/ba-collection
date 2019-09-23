#!/usr/bin/env bash

# Usage
# Run in output directory
#
# fix_monthly.sh expname

# version suffix
suff="v2"

# start and end year
start_year=1979
end_year=2015

# filename definitions
basename="ECE"
expname=$1  # experiment name

# those monthly vars should be ok
fixVars="CP LSP"
for var in ${fixVars}; do
  for yr in $(seq ${start_year} ${end_year}); do
    infile="${basename}_${expname}_${var}_monthly_${yr}.nc" # ECE_ITNV_T2M_monthly_2001.nc
    outfile="${basename}_${expname}_${var}_monthly_${yr}_v2.nc" # ECE_ITNV_T2M_monthly_2001_v2.nc
    cp "${infile}" "${outfile}"
    echo "DONE ${outfile}"
  done
done

# add scale factor to monthly instantaneous vars 
# we summed three hourly fields, first per day, then per month
# to divide by 4 to get daily, and then by days-per-month to get average 3 hourly
fixVars="MSL SP T T2M Z U V Q"
for var in ${fixVars}; do
  for yr in $(seq ${start_year} ${end_year}); do
    infile="${basename}_${expname}_${var}_monthly_${yr}.nc" # ECE_ITNV_T2M_monthly_2001.nc
    outfile="${basename}_${expname}_${var}_monthly_${yr}_${suff}.nc" # ECE_ITNV_T2M_monthly_2001_v2.nc
    if [ -f ${infile} ]; then
      cdo divdpm "${infile}" "${outfile}"
      ncatted -a scale_factor,${var},c,f,0.25 "${outfile}"
      echo "DONE ${outfile}"
    else
      echo "ERROR [file missing] ${outfile}"
    fi
  done
done

# add scale factor to monthly fluxes
# we summed three hourly fields, first per day, then per month
# to divide by 4 to get daily, and then by days-per-month to get average 3 hourly
# then by 3 * 60 * 60 to get W/m2
fixVars="SLHF SSHF STR SSR TTR TSR"
for var in ${fixVars}; do
  for yr in $(seq ${start_year} ${end_year}); do
    infile="${basename}_${expname}_${var}_monthly_${yr}.nc" # ECE_ITNV_T2M_monthly_2001.nc
    outfile="${basename}_${expname}_${var}_monthly_${yr}_${suff}.nc" # ECE_ITNV_T2M_monthly_2001_v2.nc
    if [ -f ${infile} ]; then
      cdo divdpm "${infile}" "${outfile}"
      ncatted -a scale_factor,${var},c,f,2.314814814814814e-5 "${outfile}"
      ncatted -a units,${var},o,c,"W m**-2" "${outfile}"
      echo "DONE ${outfile}"
    else
      echo "ERROR [file missing] ${outfile}"
    fi
  done
done
