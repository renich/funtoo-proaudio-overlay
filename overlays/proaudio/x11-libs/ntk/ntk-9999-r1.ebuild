# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_2,3_3} )
inherit git-2 python-any-r1 waf-utils

DESCRIPTION="A fork of the Fast Light ToolKit library, adding improved graphics rendering via Cairo"
HOMEPAGE="http://non.tuxfamily.org/wiki/NTK"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/fltk.git"

# --enable-test to waf builds and installs test programs. There is no
# test suite in the source code.
RESTRICT="test"

LICENSE="FLTK LGPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug opengl png"

RDEPEND="media-libs/fontconfig
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXft
	virtual/jpeg
	opengl? ( media-libs/glu )
	png? ( media-libs/libpng )"
DEPEND="${RDEPEND}"

DOCS=( ANNOUNCEMENT CREDITS README )
PATCHES=(
	"${FILESDIR}"/${P}-noldconfig-r1.patch
	"${FILESDIR}"/${P}-nooptimize.patch
)

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mywafconfargs=(
		--no-ldconfig
		--no-optimize
		$(usex debug --enable-debug "")
		$(usex opengl --enable-gl "")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	DESTDIR="${D}" waf-utils_src_install
}
