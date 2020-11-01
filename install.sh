#!/bin/sh
PWD=$(pwd)

function imgbuildradare2 {
    id=$(buildah from opensuse/tumbleweed)
    #Radare2 dependencies
    buildah run $id zypper in -y ccache make gcc patch git
    #r2ghidra-dec dependencies
    buildah run $id zypper in -y gcc-c++ cmake bison flex
    buildah copy $id ./buildradare2.sh / 
    buildah config \
	    --workingdir $PWD \
	    --entrypoint /buildradare2.sh \
	    --volume $HOME \
	    $id
    buildah commit $id $USER/buildradare2
    buildah rm $id
}

function buildradare2 {
    podman run\
	   --userns keep-id\
	   --volume $HOME:$HOME\
	   -it $USER/buildradare2
}

function imgbuildcutter {
    id=$(buildah from library/ubuntu)
    buildah run $id apt update
    buildah run $id apt install build-essential cmake meson libzip-dev zlib1g-dev qt5-default libqt5svg5-dev qttools5-dev qttools5-dev-tools pkg-config python3-pip git
    buildah copy $id ./buildcutter.sh / 
    buildah config \
	    --workingdir $PWD \
	    --entrypoint /buildcutter.sh \
	    --volume $PWD \
	    $id
    buildah commit $id 0pendev/buildcutter
    buildah rm $id
}

function buildcutter {
    podman run\
	   --userns keep-id\
	   --volume $HOME:$HOME\
	   -it $USER/buildcutter
}

imgbuildradare2
buildradare2
