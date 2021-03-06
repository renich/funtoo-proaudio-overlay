# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sfc/sfc-0.016.ebuild,v 1.6 2011/03/20 20:07:34 jlec Exp $

EAPI="1"

DESCRIPTION="SoundFontCombi is an opensource software pseudo synthesizer."
HOMEPAGE="http://personal.telefonica.terra.es/web/soudfontcombi/"
SRC_URI="http://personal.telefonica.terra.es/web/soudfontcombi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/alsa-lib
	x11-libs/fltk:1"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README
}
