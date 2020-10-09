#!/bin/bash

export ODAHUB=https://dqueue.staging-1-3.odahub.io@queue-osa11

function run-in-singularity() {
    echo -e "\033[33msingularity image origin:\033[0m ${IMAGE_ORIGIN:="https://www.isdc.unige.ch/~savchenk/singularity/odahub_dda_db22be8-2020-07-18-2b9b737e0fb6.sif"}"
    echo -e "\033[33m        local data store:\033[0m ${ODA_LOCAL_DATA:?please specify local data store}"

    export DDA_TOKEN=$(cat $HOME/.dda-token)

    singularity exec \
        -B runner.sh:/runner.sh \
            $IMAGE_ORIGIN \
            bash runner.sh run
}
    
function install_python_modules() {
    echo -e "\033[34m... installing recent dependencies\033[0m"
    pip install --user --upgrade \
            oda-node\>=0.1.20 \
            data-analysis 
}

function run() {
    export HOME_OVERRRIDE=/tmp/home # if many workers, choose non-overlapping
    source /init.sh
    export PATH=/tmp/home/.local/bin:$PATH

    install_python_modules

    oda-node version
}

function sync-data() {
    echo 
}

$@
