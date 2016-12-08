#!/usr/bin/env bash

set -ex

VENV=${1:-"dsvm-functional"}

GATE_DEST=$BASE/new
DEVSTACK_PATH=$GATE_DEST/devstack
NETWORKING_ODL_DIR="${NETWORKING_ODL_DIR:-$BASE/new/networking-odl}"

case $VENV in
"dsvm-functional")
    # The following need to be set before sourcing
    # configure_for_func_testing.
    PROJECT_NAME=networking-odl
    IS_GATE=True

    source $NETWORKING_ODL_DIR/tools/configure_for_func_testing.sh
    configure_host_for_func_testing
    ;;
"dsvm-fullstack")
    # Fullstack testing happens in post-test-hook.sh
    # Make the workspace owned by STACK_USER
    sudo chown -R $STACK_USER:$STACK_USER $BASE

    # TODO(rzang): set here temporarily.
    # Remove once https://review.openstack.org/#/c/400281/ gets merged
    export DEVSTACK_GATE_REMOVE_STACK_SUDO=0
    $BASE/new/devstack-gate/devstack-vm-gate.sh
    ;;
*)
    echo "Unrecognized environment $VENV".
    exit 1
esac
