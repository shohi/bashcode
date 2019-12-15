#!/usr/bin/env bash -x

#######################################################################
#                         date/datetime tools                         #
#######################################################################

# get the week number of given date.
# If no date assigned, current date will be used. Also note that
# - 1. The week of first day of the year is always `1`.
# - 2. The week starts from monday.
# The result SHOULD be the same with the value from reference 1.
#
# reference
# 1. https://wannianli.tianqi.com/2019/
# 1. http://week-number.net/programming/week-number-in-linux-shell-script.html
# 2. https://stackoverflow.com/questions/46024251/how-can-we-get-weekday-based-on-given-date-in-unix
function week_of_day() {
  local dt=${1:-$(date +'%Y-%m-%d')}

  local year
  year=$(date -j -f '%Y-%m-%d' "${dt}" +'%Y')

  if [ $? -ne 0 ]; then
    echo "malformed time - [${dt}]"
    return 1
  fi

  # week number of the first day in the year
  local fdw
  # fdw=$(date -j -f '%Y-%m-%d' "${year}-01-01" +'%V' | bc)
  fdw=$(date -j -f '%Y-%m-%d' "${year}-01-01" +'%V')

  local wk=$(date -j -f '%Y-%m-%d' "${dt}" +'%V')

  # same week with `YYYY-01-01`
  if [ "${wk}" -eq "${fdw}" ]; then
    echo "01"
    return
  fi

  if [ "${fdw}" -ne 1 ]; then
    echo "$((wk + 1))"
  else
    echo "${wk}"
  fi
}
