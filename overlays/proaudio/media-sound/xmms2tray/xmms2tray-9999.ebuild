# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils python mercurial

DESCRIPTION="XMMS2tray - systray integration for XMMS2"
HOMEPAGE="http://code.jollybox.de/wiki/Software/Xmms2tray"
EHG_REPO_URI="http://code.jollybox.de/hg/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

RDEPEND="<dev-lang/python-3
	media-sound/xmms2[python]
	dev-python/pygtk
	dev-python/notify-python"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${PN}"

src_install() {
	python setup.py install --prefix="${D}/usr" || die "Failed to create image"
	dodoc README ChangeLog

	insinto /usr/share/pixmaps
	newins data/xmms2_64.png xmms2tray.png

	make_desktop_entry xmms2tray "XMMS2tray" xmms2tray "media;AudioVideo" #"/usr/share/xmms2tray" "Multimedia"
}
