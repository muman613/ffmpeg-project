#!/bin/bash

CATALOG_PATH=catalog
BC_SCALE=2

#
#   Use bc (calculator) to calculate the value (uses BC_SCALE for decimal places)
#

function doCalculation() {
    EXPRESSION=$1
    RESULT=$(echo "scale=${BC_SCALE}; ${EXPRESSION}" | bc)
    echo ${RESULT}
}

#
#   Get the attribute from the XML file using XPATH and xmllint
#

function getStreamAttribute() {
    FILE=$1
    ATTR=$2
    RESULT="N/A"

    #   echo "Getting attribute ${ATTR} from file ${FILE}"
    if [ -f ${FILE} ]; then
        XPATH="/ffprobe/streams/stream/@${ATTR}"
        RESULT=$(xmllint --xpath ${XPATH} ${FILE} | awk -F'[="]' '!/>/{print $(NF-1)}')
    fi

    echo ${RESULT}
}

#
#   Get the attribute from the XML file using XPATH and xmllint
#

function getFormatAttribute() {
    FILE=$1
    ATTR=$2
    RESULT="N/A"

    #   echo "Getting attribute ${ATTR} from file ${FILE}"
    if [ -f ${FILE} ]; then
        XPATH="/ffprobe/format/@${ATTR}"
        RESULT=$(xmllint --xpath ${XPATH} ${FILE} | awk -F'[="]' '!/>/{print $(NF-1)}')
    fi

    echo ${RESULT}
}


MEDIA_CATALOG=$( ls -1 ${CATALOG_PATH}/*.xml)

#echo ${MEDIA_CATALOG}
echo "FileName, FileSize, StreamWidth, StreamHeight, StreamFps, StreamCount, StreamFmt"
#echo "${FORMAT_FILENAME}, ${FORMAT_FILESIZE}, ${STREAM_WIDTH}, ${STREAM_HEIGHT}, ${STREAM_FRMRATE}, ${STREAM_FRMCOUNT}, ${STREAM_PIXFMT}"

for MEDIA in ${MEDIA_CATALOG}; do
    if [ -f ${MEDIA} ]; then
        echo >&2 "========================================================================================================="
        echo >&2 "Processing '${MEDIA}'"

        FORMAT_FILENAME=$(getFormatAttribute ${MEDIA} filename)
        FORMAT_FILESIZE=$(getFormatAttribute ${MEDIA} size)
        STREAM_WIDTH=$(getStreamAttribute ${MEDIA} width)
        STREAM_HEIGHT=$(getStreamAttribute ${MEDIA} height)
        STREAM_FRMRATE=$(getStreamAttribute ${MEDIA} r_frame_rate)
        STREAM_FRMRATE=$(doCalculation ${STREAM_FRMRATE})
        STREAM_FRMCOUNT=$(getStreamAttribute ${MEDIA} nb_read_frames)
        STREAM_PIXFMT=$(getStreamAttribute ${MEDIA} pix_fmt)

        echo >&2 "Stream Path       : ${FORMAT_FILENAME}"
        echo >&2 "Stream Filesize   : ${FORMAT_FILESIZE} Bytes"
        echo >&2 "Stream Dimensions : ${STREAM_WIDTH}X${STREAM_HEIGHT}"
        echo >&2 "Stream Framerate  : ${STREAM_FRMRATE} FPS"
        echo >&2 "Stream Framecount : ${STREAM_FRMCOUNT} Frames"
        echo >&2 "Stream Pixel Fmt  : ${STREAM_PIXFMT}"

        echo "${FORMAT_FILENAME}, ${FORMAT_FILESIZE}, ${STREAM_WIDTH}, ${STREAM_HEIGHT}, ${STREAM_FRMRATE}, ${STREAM_FRMCOUNT}, ${STREAM_PIXFMT}"
    fi
    COUNT=$(( COUNT + 1 ))
done
echo >&2 "Processed ${COUNT} streams..."
