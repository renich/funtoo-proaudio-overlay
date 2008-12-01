# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

DESCRIPTION="Multitrack guitar tablature editor and player with multitrack display, autoscroll while playing, various effects, import and export gp3 and gp4 files, and more."
HOMEPAGE="http://www.tuxguitar.com.ar"
MY_P="${P}-linux"
SRC_URI="x86? ( mirror://sourceforge/tuxguitar/${MY_P}-x86.tar.gz )
	ppc? ( mirror://sourceforge/tuxguitar/${MY_P}-ppc.tar.gz )
	amd64? ( mirror://sourceforge/tuxguitar/${MY_P}-x86_64.tar.gz )"
LICENSE="LGPL"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${A/.tar.gz/}"
src_install() {
	dodir "/opt/${MY_P}"
	insinto "/opt/${MY_P}"
	doins tuxguitar  tuxguitar.jar
	fperms 0755 /opt/${MY_P}/lib/*.so "/opt/${MY_P}/tuxguitar"
	mv files doc lib share "${D}/opt/${MY_P}"
	newbin ${FILESDIR}/${P} tuxguitar
}

pkg_postinst(){
	 einfo "$P is installed in /opt/${MY_P}"
	 einfo "type tuxguitar to start the application"
#	 einfo "some example files are in /opt/${MY_P}/examples"
}