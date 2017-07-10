#!/bin/bash

# 0. check work directory
WORK_DIR=`pwd`
SRC_DIR="$(dirname "$0")"

if ! [[ "$0" = /* ]]; then
    SRC_DIR="$(pwd)/$(dirname "$0")"
fi

cd ${SRC_DIR}

# 1. get params
rounds=20
concurrency=100
iterations=50
detailMetrics=false

otherParams=""
for param in $*
do 
    flag="${param:0:4}"
    val=${param:4}
    if [[ ${flag} == "-br=" ]]; then
        rounds=${val}
    elif [[ ${flag} = "-bc=" ]]; then
        currency=${val}
    elif [[ ${flag} = "-bi=" ]]; then
        iteration=${val}
    elif [[ ${flag} = "-bm=" ]]; then
        detailMetrics=$val}
    else
        otherParams="${otherParams} $param"
    fi
done
echo ${otherParams}

config_path="data/config.xml"
new_config_path="data/new_config.xml"

if [ ! -f ${config_path} ]; then
    echo "config file not found: ${config_path} "
    exit 1
fi

echo -n > ${new_config_path}

declare -a items=("rounds" "concurrency" "iterations" "detailMetrics")

# 2. rewrite config file
function put_config_item() {
    filepath=$2
    for item in "${items[@]}"
    do
        if [[ $1 == *"<${item}>"* ]]; then
            eval "local temp=\$${item}"       
            echo "<${item}>${temp}</${item}>" >> $2
            return
        fi
    done

    # default 
    echo $1 >> $2
}

while IFS= read -r line || [ -n "$line" ]
do 
    if [ -z "$line" ]; then
        echo $line >> ${new_config_path}
    else
        put_config_item $line ${new_config_path}
    fi
done <  ${config_path}


# 3. rename file
rm -rf ${config_path}
mv ${new_config_path} ${config_path}


# 4. call benchmark
./benchmark.sh ${otherParams}
 exit_code=$?
if [[ ${exit_code} != 0 ]]; then
    echo ""
    echo ""
    echo "other options: "
    echo " -br rounds "
    echo " -bi iterations "
    echo " -bc concurrency "
    echo " -bm detailMetrics (true/false)"
    echo ""
fi
