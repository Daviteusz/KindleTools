#!/bin/sh

exec_shell="bash" # set the shell you like (for koreader)

base_dir="/mnt/us/documents"
log_pattern_kpp="KPPMainAppV2*"
log_pattern_tmd="tmd_*"

clean_logs() {
  local log_pattern=$1

  # Find crash logs
  txt_file=$(find "$base_dir" -name "$log_pattern.txt")
  tgz_archive=$(find "$base_dir" -name "$log_pattern.tgz")
  sdr_directory=$(find "$base_dir" -type d -name "$log_pattern.sdr")

  # Initialize variables to track which types of files were deleted
  txt_deleted=0
  tgz_deleted=0
  sdr_deleted=0

  # Delete files and update corresponding variables
  if [ -n "$txt_file" ]; then
    find "$base_dir" -name "$log_pattern.txt" -exec rm {} +
    txt_deleted=1
  fi

  if [ -n "$tgz_archive" ]; then
    find "$base_dir" -name "$log_pattern.tgz" -exec rm {} +
    tgz_deleted=1
  fi

  if [ -n "$sdr_directory" ]; then
    find "$base_dir" -type d -name "$log_pattern.sdr" -exec rm -rf {} +
    sdr_deleted=1
  fi

  return $((txt_deleted + tgz_deleted + sdr_deleted))
}

kual_function() {
  clean_logs "$log_pattern_kpp"
  kpp_status=$?

  clean_logs "$log_pattern_tmd"
  tmd_status=$?

  if [ $kpp_status -eq 0 ] && [ $tmd_status -eq 0 ]; then
    fbink -pmh -y -5 -F TERMINUS "There is nothing" "to remove"
  elif [ $kpp_status -lt 3 ] || [ $tmd_status -lt 3 ]; then
    fbink -pmh -y -5 -F TERMINUS "Not all logs" "have been deleted."
    sleep 3
    fbink -pmh -y -5 -F TERMINUS "Wait ≈5 min" "and try again"
  else
    fbink -pmh -y -5 -F TERMINUS "Logs" "removed successfully!"
  fi
}

koreader_function() {
  echo -e "**** KPPMainAppV2 ****"
  echo -e "* Crash Logs Remover *\n"
  sleep 2

  clean_logs "$log_pattern_kpp"
  kpp_status=$?

  clean_logs "$log_pattern_tmd"
  tmd_status=$?

  if [ $kpp_status -eq 0 ] && [ $tmd_status -eq 0 ]; then
    echo "KPP Crash Logs not found"
    sleep 2
    echo "If you ran this right after starting KOReader,"
    echo "wait 5 minutes and run terminal again."
    sleep 6
  elif [ $kpp_status -lt 3 ] || [ $tmd_status -lt 3 ]; then
    echo "- Warning: Not all logs have been removed"
    sleep 3
    echo "  Wait ≈5 min and rerun terminal again"
    sleep 3
  else
    echo "- Logs removed successfully"
    sleep 3
  fi

  echo -en "\e[1;1H\e[2J"
  exec "$exec_shell"
}

if [ "$1" = "--kual" ]; then
  kual_function
elif [ "$1" = "--koreader" ]; then
  koreader_function
else
  echo "Usage: $0 --kual | --koreader"
fi
