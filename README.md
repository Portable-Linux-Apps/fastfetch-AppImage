# fastfetch-AppImage

This repo takes the [official fastfetch binaries ](https://github.com/fastfetch-cli/fastfetch/releases) and turns them into an AppImage. 

No libraries or other dependencies are bundled in, since the official binaries are already portable enough.

-----------------------------------------------------------------------------------------------------------------

# Why should I use this? 

You get the following advantages: 

* Easy integration into the system using AppImage integration tools like [AM](https://github.com/ivan-hc/AM), [soar](https://github.com/pkgforge-dev/soar), [dbin](https://github.com/xplshn/dbin) and others.

* Less storage usage since the AppImage sits compressed on disk while the tarball has to be extracted.

* The ability to easily have a [portable home/config](https://docs.appimage.org/user-guide/portable-mode.html) dir together with the application, with tarballs you have to make some ugly wrapper scripts instead. 

* Delta updates with [AppImageUpdate](https://github.com/AppImageCommunity/AppImageUpdate). This means **you don't download the entire application again with an update, but only the diff.** Also see our [fork](https://github.com/pkgforge-dev/AppImageUpdate-Enhanced-Edition) used by AM.

* It uses the [uruntime](https://github.com/VHSgunzo/uruntime), which makes this AppImage able to work without FUSE on the host at all, **as well as have startup time as fast as if the binary was extracted on the system.**
