{ mkDerivation, aeson, async, base, containers, data-default
, directory, filepath, lib, mtl, optics-core, profunctors, relude
, shower, time, with-utf8, X11, xmobar, xmonad, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-config";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson async base containers data-default directory filepath mtl
    optics-core profunctors relude shower time with-utf8 X11 xmobar
    xmonad xmonad-contrib
  ];
  description = "My personal xmonad + xmobar configuration";
  license = lib.licensesSpdx."MIT";
}
