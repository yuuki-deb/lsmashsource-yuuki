ARG os
FROM buildpack-deps:$os

ARG os
ARG os_cache_date
RUN curl https://yuuki-deb.x86.men/public.key | apt-key add - &&\
    echo "deb http://yuuki-deb.x86.men/ $os main" > /etc/apt/sources.list.d/yuuki-deb.list &&\
    wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb &&\
    dpkg -i deb-multimedia-keyring_2016.8.1_all.deb &&\
    echo "deb http://www.deb-multimedia.org $os main non-free" > /etc/apt/sources.list.d/dmo.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y debhelper devscripts po-debconf dpkg-dev meson avisynthplus-yuuki-dev liblsmash-yuuki-dev vapoursynth-dev libavcodec-dev libavformat-dev libavutil-dev libswresample-dev libswscale-dev &&\
    rm -rf /var/lib/apt/lists/*

WORKDIR /build/
SHELL ["/bin/bash", "-c"]
ARG os
ARG git_tag
RUN git clone https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works.git lsmashsource &&\
    cd lsmashsource &&\
    git checkout $git_tag

ARG rev=1
COPY debian lsmashsource/debian
RUN cd /build/lsmashsource &&\
    dch --distribution $os -l +$os "Porting to $os" -m -t &&\
    for ((i=1; i<$rev; i++)); do dch --distribution $os -l +$os "Rebuild" -m -t; done &&\
    debian/rules binary &&\
    mkdir /build/reg &&\
    mv /build/*.deb /build/reg
