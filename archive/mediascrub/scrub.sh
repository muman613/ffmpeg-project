#!/bin/bash

MEDIAROOT=/media/elementary/hevc/
OUTPUTPATH=catalog

function filesize() {
    FILE=$1
#    echo "FILE [${FILE}]"
    RESULT=$(stat --printf "%s\n" ${FILE})

    echo "${RESULT}"
}


if [ ! -d ${OUTPUTPATH} ]; then
    mkdir ${OUTPUTPATH}
fi

MEDIAFILES=$(find ${MEDIAROOT} \( -iname "*.hevc" -o -iname "*.265" \) -a -type f)

for FILE in ${MEDIAFILES}; do
    BASEFN=$(basename ${FILE})
    if [ -e ${FILE} ]; then
        SIZE=$(filesize ${FILE})

        RELPATH=$(echo ${FILE} | sed 's/\/media\/elementary\/hevc\///')
        RELPATH=$(echo ${RELPATH} | sed 's/\//-/g')
        OUTFILE=${OUTPUTPATH}/${RELPATH}.xml
#       echo "${OUTFILE}"
        # OUTFILE=${OUTPUTPATH}/${BASEFN}.xml
        PRINTSTR=$(printf "Analyzing file %s / %s / %d\n" ${FILE} ${BASEFN} ${SIZE})
        echo >&2 ${PRINTSTR}
        if [ -f ${OUTFILE} ]; then
            echo "FILE ${BASEFN} ALREADY EXISTS!"
        fi
        START=$(date +%T)
        ffprobe -v quiet -print_format xml -show_format -show_streams -count_frames ${FILE} > ${OUTFILE}
        END=$(date +%T)
        DIFF=$(dateutils.ddiff ${START} ${END} -f "%M:%S")
        echo >&2 "Start ${START} End ${END} Diff ${DIFF}"
#       touch ${OUTFILE}
    fi
done


