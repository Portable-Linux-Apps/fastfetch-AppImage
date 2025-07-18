#!/bin/sh

set -ex

ARCH=$(uname -m)
REPO="https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest"
APPIMAGETOOL="https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-$ARCH.AppImage"
UPINFO="gh-releases-zsync|$(echo $GITHUB_REPOSITORY | tr '/' '|')|latest|*$ARCH.AppImage.zsync"
export URUNTIME_PRELOAD=1 # really needed here

# fastfetch uses amd64 instead of x86_64
if [ "$(uname -m)" = 'x86_64' ]; then
	ARCH=amd64
fi

tarball_url=$(wget "$REPO" -O - | sed 's/[()",{} ]/\n/g' \
	| grep -oi "https.*linux-$ARCH.tar.gz$" | head -1)

export ARCH=$(uname -m)
export VERSION=$(echo "$tarball_url" | awk -F'/' '{print $(NF-1); exit}')
echo "$VERSION" > ~/version

wget "$tarball_url" -O ./package.tar.gz
tar xvf ./package.tar.gz
rm -f ./package.tar.gz
mv -v ./fastfetch-linux-* ./AppDir

echo '#!/bin/sh
CURRENTDIR="$(readlink -f "$(dirname "$0")")"
export PATH="$CURRENTDIR/usr/bin:$PATH"
ARGV0="${ARGV0:-$0}"

if [ "${ARGV0#./}" = "flashfetch" ]; then
	exec "$CURRENTDIR"/usr/bin/flashfetch "$@"
else
	exec "$CURRENTDIR"/usr/bin/fastfetch "$@"
fi' > ./AppDir/AppRun
chmod +x ./AppDir/AppRun

echo '[Desktop Entry]
Type=Application
Name=fastfetch
Icon=fastfetch
Exec=fastfetch
Categories=System
Hidden=true' > ./AppDir/fastfetch.desktop
touch ./AppDir/fastfetch.png ./AppDir/.DirIcon

# get polyfil glibc so that fastfetch can work on older distros
git clone https://github.com/corsix/polyfill-glibc.git && (
	cd ./polyfill-glibc
	ninja polyfill-glibc
)
./polyfill-glibc/polyfill-glibc --target-glibc=2.17 ./AppDir/usr/bin/*


wget "$APPIMAGETOOL" -O ./appimagetool
chmod +x ./appimagetool
./appimagetool -n -u "$UPINFO" ./AppDir


