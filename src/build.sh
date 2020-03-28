#!/bin/bash

distributions="${@:-buster}"
reg='_(.*)\+'
os_cache_date=$(date +%Y-%W)
git_tag=${git_tag:-6f4e29f4afb05c3ee9a98eccaba4456d897b0915}
rev=${rev:-1}

echo OS Cache: $os_cache_date
echo Git Tag: $git_tag
echo Build Rev: $rev

for distribution in $distributions; do
  docker build \
    --add-host=deb.debian.org:185.255.55.26 \
    --add-host=security.debian.org:185.255.55.26 \
    --add-host=archive.ubuntu.com:185.255.55.26 \
    --add-host=security.ubuntu.com:185.255.55.26 \
    --build-arg os=$distribution \
    --build-arg os_cache_date=$os_cache_date \
    --build-arg git_tag=$git_tag \
    --build-arg rev=$rev \
    -t avsp-lsmashsource:$distribution .

  build_dir=`docker inspect avsp-lsmashsource:$distribution | jq -r '.[0].GraphDriver.Data.UpperDir'`/build

  [[ $(ls $build_dir/reg/dualsynth-lsmashsource-yuuki_*.deb | head -1) =~ $reg ]]
  version=${BASH_REMATCH[1]}
  mkdir -p ../dist/$version
  rm -rf ../dist/$version/$distribution
  rm -f $build_dir/reg/*dbgsym*
  cp -r $build_dir/reg ../dist/$version/$distribution
done
