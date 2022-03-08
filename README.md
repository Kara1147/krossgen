# EWS (Exchange Web Services) CLI
Command-line tool designed for manual (and verbose) interaction with an EWS
server, in case you need that level of diagnostics.

This will only compile for windows. Currently, I use the mingw-w64 toolchain
for linux.

## Library requirements
*(make sure you have these built for and installed on your toolchain)*
* openssl

>*If you're using Arch and compiling for windows using mingw-w64, you may find
the following packages useful:*
>* *mingw-w64-openssl <sup>[AUR](https://aur.archlinux.org/packages/mingw-w64-openssl)</sup>*

## Additional Information
This appliction is set up to be built using autotools. You may use
`autoreconf --install` to produce `./configure`. It's a good idea to use
`./configure` in a `build/` subdirectory or outside of the build tree.

Feel free to propose changes to the functionality or documentation of this
application.
