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
            oda-node\>=0.1.21 \
            data-analysis 
}

function sync-ic() {
    echo -e "\033[34m... synching semi-permanent data (IC tree) to REP_BASE_PROD=${REP_BASE_PROD:?}\033[0m"
    set -e

    mkdir -pv $REP_BASE_PROD/idx/scw/
    wget https://www.isdc.unige.ch/~savchenk/GNRL-SCWG-GRP-IDX.fits -O $REP_BASE_PROD/idx/scw/GNRL-SCWG-GRP-IDX.fits

    mkdir -pv $REP_BASE_PROD/aux/org/ref/
    rsync -avu ftp://isdcarc.unige.ch/arc/rev_3/aux/org/ref/ $REP_BASE_PROD/aux/org/ref/
    rsync -avu ftp://isdcarc.unige.ch/arc/rev_3/cat/ $REP_BASE_PROD/cat/

    rsync -Lzrtv isdcarc.unige.ch::arc/FTP/arc_distr/ic_tree/prod/ $REP_BASE_PROD/

    
}
    
function sync-all() {
    echo -e "\033[34mwill sync:\033[0m: ${SYNC:=python-modules ic}"
    for sync in $SYNC; do
        echo -e "\033[34m... sync:\033[0m: $sync"
        sync-$sync
    done
}

function test-osa() {
    which ibis_science_analysis
    plist ibis_science_analysis
    echo "managed!"
}

function test-odahub() {
    oda-node version
}

function self-test() {
    for a_test in test-osa test-odahub; do
        if $a_test > log-$a_test 2>&1; then
            echo -e "$a_test \033[32mPASSED\033[0m"
        else
            echo -e "$a_test \033[31mFAILED\033[0m"
            cat $a_test
        fi
    done
}

function run() {
    args=$@
    export HOME_OVERRRIDE=/tmp/home # if many workers, choose non-overlapping
    source /init.sh
    export PATH=/tmp/home/.local/bin:$PATH
    export REP_BASE_PROD=/data/
    export INTEGRAL_DATA=$REP_BASE_PROD
    export CURRENT_IC=$REP_BASE_PROD
    export INTEGRAL_DDCACHE_ROOT=/data/reduced/ddcache/

    $args
}

$@
