#!/bin/bash

# find  *.bin and *.cue files in this directory  
FILES=`find . -type f -name "*.bin"`

# make the *.flac file inclued all tracks
function make_full_flac() {
  BASENAME=`basename $1 .bin`
  echo ${BASENAME}
  flac -f \
      --best --force-raw-format \
      --endian=little \
      --channels=2 \
      --bps=16 \
      --sample-rate=44100 \
      --sign=signed \
      --cuesheet="${BASENAME}.cue" "${BASENAME}.bin"
}

# split *.flac wiht *.cue file
function split_full_flac() {
  BASENAME=`basename $1 .flac`
  cuebreakpoints "${BASENAME}.cue" | shnsplit -o flac "${BASENAME}.flac"
}

# convert *.flac to *.mp3
function convert_flac_to_mp3() {
  BASENAME=`basename $1 .flac`
  ffmpeg -i $1 -ab 320k -map_metadata 0 -id3v2_version 3 ${BASENAME}.mp3
}

# rename mp3 files
function rename_mp3_files() {
  MP3_FILES=`find . -type f -name "*.mp3"`
  for MP3_FILE in ${MP3_FILES}; do
    rename -v "s/split-track/track/" "${MP3_FILE}"
  done
}

# execute this shell script
for FILE in ${FILES}; do
  make_full_flac ${FILE}
  BASENAME=`basename ${FILE} .bin`
  FULL_FLAC_FILES=`find . -type f -name "${BASENAME}*.flac"`

  for FULL_FLAC_FILE in ${FULL_FLAC_FILES}; do
    split_full_flac ${FULL_FLAC_FILE}
    rm -rf ${FULL_FLAC_FILE}
  done

  FLACS=`find . -type f  -name "split-track*.flac"`
  for FLAC in ${FLACS}; do
    convert_flac_to_mp3 ${FLAC}
    rm -rf ${FLAC}
  done

  FLACS=`find . -type f -name "*.mp3"`
  for FLAC in ${FLACS}; do
    echo "\$FLAC: ${FLAC} / \$FILE: ${FILE}"

    rename "s/split-track/`basename ${FILE} .bin`-track/" ${FLAC}
  done
  
done
