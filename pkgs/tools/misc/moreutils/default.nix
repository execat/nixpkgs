{ lib, stdenv, fetchgit, libxml2, libxslt, docbook-xsl, docbook_xml_dtd_44, perlPackages, makeWrapper, darwin }:

with lib;
stdenv.mkDerivation rec {
  pname = "moreutils";
  version = "0.66";

  src = fetchgit {
    url = "git://git.joeyh.name/moreutils";
    rev = "refs/tags/${version}";
    sha256 = "sha256-y+imKvLbaegpI4GTVPuHFT43OGFGnzOnWP2J3LSX1BQ=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace /usr/share/xml/docbook/stylesheet/docbook-xsl ${docbook-xsl}/xml/xsl/docbook
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libxml2 libxslt docbook-xsl docbook_xml_dtd_44 ]
    ++ optional stdenv.isDarwin darwin.cctools;

  propagatedBuildInputs = with perlPackages; [ perl IPCRun TimeDate TimeDuration ];

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/chronic --prefix PERL5LIB : $PERL5LIB
    wrapProgram $out/bin/ts --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    description = "Growing collection of the unix tools that nobody thought to write long ago when unix was young";
    homepage = "https://joeyh.name/code/moreutils/";
    maintainers = with maintainers; [ koral pSub ];
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
