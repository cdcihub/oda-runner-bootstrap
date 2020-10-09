#!/bin/bash

export ODAHUB=https://dqueue.staging-1-3.odahub.io@queue-osa11

function container() {
    args=$@

    echo -e "\033[33msingularity image origin:\033[0m ${IMAGE_ORIGIN:="https://www.isdc.unige.ch/~savchenk/singularity/odahub_dda_db22be8-2020-07-18-2b9b737e0fb6.sif"}"
    echo -e "\033[33m        local data store:\033[0m ${ODA_LOCAL_DATA:?please specify local data store}"

    export DDA_TOKEN=$(cat $HOME/.dda-token)

    singularity exec \
        -B runner.sh:/runner.sh \
        -B $ODA_LOCAL_DATA:/data \
            $IMAGE_ORIGIN \
            bash runner.sh $args
}
    
function sync-python-modules() {
    echo -e "\033[34m... installing recent dependencies\033[0m"
    pip install --user --upgrade \
            oda-node\>=0.1.20 \
            data-analysis 
}

function sync-ic() {
    echo -e "\033[34m... synching semi-permanent data (IC tree) to REP_BASE_PROD=${REP_BASE_PROD:?}\033[0m"
    rsync -Lzrtv isdcarc.unige.ch::arc/FTP/arc_distr/ic_tree/prod/ $REP_BASE_PROD/
}
    
function sync-all() {
    echo -e "\033[34mwill sync:\033[0m: ${SYNC:=python-modules ic}"
    for sync in $SYNC; do
        echo -e "\033[34m... sync:\033[0m: $sync"
        sync-$sync
    done
}

function run() {
    args=$@
    export HOME_OVERRRIDE=/tmp/home # if many workers, choose non-overlapping
    source /init.sh
    export PATH=/tmp/home/.local/bin:$PATH

    sync-all

    oda-node version
    
    $args
}

function sync-data() {
    echo 
}

$@
