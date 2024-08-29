CABEXTRACT BUILD PREREQUISITES

Install these packages on a Linux host to compile binaries:

* Open Watcom 1.9 or v2.
* awk
* sed

Install these packages to create a FreeDOS package:

* advzip
* dos2unix
* git
* upx

And install these packages for unit testing:

* dosbox
* flatpak

Download links:

* https://github.com/open-watcom/open-watcom-v2/releases/latest
* https://github.com/amadvance/advancecomp/releases/latest
* https://github.com/upx/upx/releases/latest


CABEXTRACT BUILD INSTRUCTIONS

1. Ensure that these two environment variables are set appropriately.

  $ export WATCOM=/opt/watcom
  $ export PATH="$WATCOM/binl:$PATH"

2. Unpack the libmspack sources; symlinks must be preserved.

  $ unzip SOURCES.ZIP

3. Change directory into the DOS build area.

  $ cd cabextract/dos

4. Run the executable wmake file.

  $ ./Makefile
  $ ls products


CABEXTRACT PACKAGING INSTRUCTIONS

Recreate the FreeDOS FDIMPLES package from the downstream repository.

  $ git clone https://github.com/dajhorn/libmspack
  $ cd libmspack/cabextract/dos
  $ ./Makefile package


CABEXTRACT TESTING INSTRUCTIONS

DOSBox emulates the runtime platform.

  $ flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  $ flatpak install flathub com.dosbox_x.DOSBox-X

All unit tests appropriate for DOS are included.

  $ ./Makefile test

Ensure that the dbus service is running if the DOSBox container is slow to
start or stop, or just install DOSBox locally and adjust the Makefile.
