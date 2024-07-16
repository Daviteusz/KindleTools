#!/bin/sh

version="v1.3"
base_dir="./mnt/us/documents"
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
    find "$base_dir" -type d -name "$log_pattern.sdr" -exec rm -r {} +
    sdr_deleted=1
  fi

  echo $((txt_deleted + tgz_deleted + sdr_deleted))
}

kual_function() {
  echo "** CrashLogs Cleaner "$version" **"
  sleep 1
  kpp_status=$(clean_logs "$log_pattern_kpp")
  tmd_status=$(clean_logs "$log_pattern_tmd")

  if [ $kpp_status -eq 0 ] && [ $tmd_status -eq 0 ]; then
    fbink -pmh -y 14 -F TERMINUS "Crash logs not found." "Horray!"
  else
    if [ $kpp_status -eq 3 ] && [ $tmd_status -eq 3 ] ; then
      fbink -pmh -y 14 -F TERMINUS "Crash Logs removed" "successfully!"
      sleep 3
    elif [ $kpp_status -lt 3 ] && [ $tmd_status -eq 3 ]; then
      fbink -pmh -y 14 -F TERMINUS "Warning: Not all "KPPMainAppV2_*" crash logs have been removed"
      sleep 3
      fbink -pmh -y 16 -F TERMINUS "Wait ≈5 min and rerun terminal again"
      sleep 3
    elif [ $tmd_status -lt 3 ] && [ $kpp_status -eq 3 ]; then
      fbink -pmh -y 14 -F TERMINUS "Warning: Not all tmd_* crash logs" "have been removed"
      sleep 3
      fbink -pmh -y 16 -F TERMINUS "Wait ≈5 min and rerun terminal again"
      sleep 3
    elif [ $tmd_status -lt 3 ] && [ $kpp_status -lt 3 ]; then
      fbink -pmh -y 14 -F TERMINUS "Warning: Not all crash logs" "have been removed"
      sleep 3
      fbink -pmh -y 16 -F TERMINUS "Wait ≈5 min and rerun terminal again"
      sleep 3
    fi
  fi
}

koreader_function() {
  echo "** CrashLogs Cleaner "$version" **"
  sleep 1

  kpp_status=$(clean_logs "$log_pattern_kpp")
  tmd_status=$(clean_logs "$log_pattern_tmd")

  if [ $kpp_status -eq 0 ] && [ $tmd_status -eq 0 ]; then
    echo "Crash logs not found. Horray!"
  else
    if [ $kpp_status -eq 3 ] && [ $tmd_status -eq 3 ] ; then
      echo "Crash Logs removed successfully!"
      sleep 3
    elif [ $kpp_status -lt 3 ] && [ $tmd_status -eq 3 ]; then
      echo "Warning: Not all "KPPMainAppV2_*" crash logs have been removed"
      sleep 2
      echo "Wait ≈5 min and rerun terminal again"
      sleep 2
    elif [ $tmd_status -lt 3 ] && [ $kpp_status -eq 3 ]; then
      echo "Warning: Not all "tmd_*" crash logs have been removed"
      sleep 3
      echo "Wait ≈5 min and rerun terminal again"
      sleep 3
    elif [ $tmd_status -lt 3 ] && [ $kpp_status -lt 3 ]; then
      echo "Warning: Not all logs have been removed"
      sleep 3
      echo "Wait ≈5 min and rerun terminal again"
      sleep 3
    fi
  fi
}

if [ "$1" = "--kual" ]; then
  kual_function
elif [ "$1" = "" ]; then
  koreader_function
else
  echo "Usage: $0"
fi
