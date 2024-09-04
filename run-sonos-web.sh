#!/usr/bin/env bash

# https://stackoverflow.com/questions/30449313/how-do-i-make-a-docker-container-start-automatically-on-system-boot
# https://github.com/containers/podman/pull/6522

do_syntax() {
    echo "run-sonos-web.sh <s1|s2|stop-s1|stop-s2> -d"
    echo 'with "-d" option, container runs in foreground, otherwise background'
}

# ========= Check docker =======================================
check_container() {
    if ! command -v podman &>/dev/null; then
        echo "docker"
    else
        echo "podman"
    fi
}

# ========= Start =======================================
do_start_s1() {
    local container_cmd=$1
    shift
    local container_name=$1
    shift
    local debug=$1

    bg="-d"
    [[ ! -z "${debug}" ]] && bg=""

    $container_cmd run $bg \
        --restart unless-stopped \
        --net=host \
        --name "$container_name" \
        -e PORT=5050 \
        -e SONOS_LISTENER_PORT=4000 \
        -e WHITELIST="Connect" \
        -t webcliff/sonos-web:latest
}

do_start_s2() {
    local container_cmd=$1
    shift
    local container_name=$1
    shift
    local debug=$1

    bg="-d"
    [[ ! -z "${debug}" ]] && bg=""

    $container_cmd run $bg \
        --restart unless-stopped \
        --net=host \
        --name "$container_name" \
        -e PORT=5051 \
        -e SONOS_LISTENER_PORT=4001 \
        -e WHITELIST="Move,Sub,Playbar,Play:5" \
        -t webcliff/sonos-web:latest
}

# ========= Stop =======================================
do_stop() {
    local container_cmd=$1
    local container_name=$2
    IMAGE=$($container_cmd ps -q --filter name=$container_name)
    if [[ -n $IMAGE ]]; then
        echo "stopping container $IMAGE"
        $container_cmd stop $IMAGE
        sleep 1
    else
        echo "container not found"
        exit 1
    fi
}

#### Main

if [[ $# -gt 2 ]]; then
    do_syntax
    exit 1
fi

action=$1
shift

debug=$1

container_cmd=$(check_container)
name="sonos-web"

case "$action" in
    s1)
        do_start_s1 "$container_cmd" "${name}-s1" $debug
        ;;
    s2)
        do_start_s2 "$container_cmd" "${name}-s2" $debug
        ;;
    stop-s1)
        do_stop "$container_cmd" "${name}-s1"
        ;;
    stop-s2)
        do_stop "$container_cmd" "${name}-s2"
        ;;
    *)
        do_syntax
        exit 1
        ;;
esac

exit 0
