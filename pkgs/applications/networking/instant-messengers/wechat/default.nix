{ stdenv
, lib
, dpkg
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "wechat";
  version = "2.1.1";

  src = fetchurl {
    url = "http://archive.ubuntukylin.com/software/pool/partner/weixin_${version}_amd64.deb";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [
    dpkg
  ];

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root 
  '';

  dontBuild = true;

  buildInputs = with xorg; [

  ];

  installPhase = ''
  '';

  postFixup = ''
  '';

  meta = with lib; {
    description = "a linux version provide by kylinUbuntu";
    homepage = "https://www.ubuntukylin.com/applications/106-cn.html";
    platforms = [
      "x86_64-linux"
    ];
  };
}
