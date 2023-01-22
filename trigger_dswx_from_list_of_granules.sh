#! /bin/bash

########################################################################
# loop through HLS granules and submit download jobs for them          #
#                   												   #
# usage: ./trigger_dswx_from_list_of_granules.sh <hls list> [--dryrun] #
# - hls_list is a list of HLS granules                                 #
# - use --dryrun or -d to only print the command that will be run      #
########################################################################

HLS_LIST=$1
DRYRUN=false
if [[ $2 == "--dryrun" || $2 == "-d" ]]; then
	DRYRUN=true
fi

RELEASE_VERSION="1.0.0-rc.7.0"

for granule in $( cat $HLS_LIST ); do 

	if  [[ ${granule:4:1} == "S" ]]; then
		collection="HLSS30"
	elif [[ ${granule:4:1} == "L" ]]; then
		collection="HLSL30"
	else
		echo "invalid granule format: $granule"
		exit 1
	fi

	if $DRYRUN; then
		echo "~/mozart/ops/opera-pcm/data_subscriber/daac_data_subscriber.py query -c $collection -p LPCLOUD --release-version=$RELEASE_VERSION --job-queue=opera-job_worker-hls_data_download --chunk-size=1 --native-id=$granule"
	else
		~/mozart/ops/opera-pcm/data_subscriber/daac_data_subscriber.py query -c $collection -p LPCLOUD --release-version=$RELEASE_VERSION --job-queue=opera-job_worker-hls_data_download --chunk-size=1 --native-id=$granule
	fi

done
