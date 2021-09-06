#!/bin/bash

FILES=`find . -type f -name "*.bin"`

FLAC_FILES=`find . -type f -name "Disc*-track??.flac"`

function make_full_flac() {
  BASENAME=`basename $1 .bin`
  echo ${BASENAME}
  flac -f --best --force-raw-format \
          --endian=little \
          --channels=2 \
          --bps=16 \
          --sample-rate=44100 \
          --sign=signed \
          --cuesheet="${BASENAME}.cue" "${BASENAME}.bin"
}

function split_full_flac() {
  BASENAME=`basename $1 .flac`
  cuebreakpoints "${BASENAME}.cue" | shnsplit -o flac "${BASENAME}.flac"
  rename -v "s/split-track0/${BASENAME}-track0/" *.flac
}

function convert_flac_to_mp3() {
  BASENAME=`basename $1 .flac`
  ffmpeg -i $1 -ab 320k -map_metadata 0 -id3v2_version 3 ${BASENAME}.mp3
}

for FILE in ${FILES}; do
  make_full_flac ${FILE}
  BASENAME=`basename ${FILE} .bin`
  FULL_FLAC_FILES=`find -type f -name "${BASENAME}.flac"`

  for FULL_FLAC_FILE in ${FULL_FLAC_FILES}; do
    split_full_flac ${FULL_FLAC_FILE}
    rm -rf ${FULL_FLAC_FILE}
  done

  rm -rf ${BASENAME}.flac

  FLACS=`find . -type f -name "${BASENAME}*.flac"`
  for FLAC in ${FLACS}; do
    convert_flac_to_mp3 ${FLAC}
    rm -rf ${FLAC}
  done
done
