# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils
RESTRICT="mirror"
MY_P=ZynAddSubFX-${PV}
DESCRIPTION="ZynAddSubFX is an opensource software synthesizer."
HOMEPAGE="http://zynaddsubfx.sourceforge.net/"
SRC_URI="mirror://sourceforge/zynaddsubfx/${MY_P}.tar.bz2
	http://download.tuxfamily.org/proaudio/distfiles/zynaddsubfx-presets-0.1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="oss alsa jack jackmidi lash mmx"

DEPEND=">=x11-libs/fltk-1.1.2
	=sci-libs/fftw-3*
	 media-sound/jack-audio-connection-kit
	>=dev-libs/mini-xml-2.2.1
	lash? ( virtual/liblash )"

RDEPEND="media-libs/zynaddsubfx-banks"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# add our CXXFLAGS
	cd src/
	esed_check -i "s@\(CXXFLAGS.\+=.*OS_PORT.*\)@\1 ${CXXFLAGS}@g" Makefile
}

src_compile() {
	local FFTW_VERSION=3
	local ASM_F2I=NO
	local LINUX_MIDIIN=NONE
	local LINUX_AUDIOOUT=NONE
	local LINUX_USE_LASH=NO

	if use oss ; then
		LINUX_MIDIIN=OSS
		LINUX_AUDIOOUT=OSS
		use jack && LINUX_AUDIOOUT=OSS_AND_JACK
	else
		use jack && LINUX_AUDIOOUT=JACK
	fi

	use lash && LINUX_USE_LASH=YES
	use jackmidi && LINUX_USE_JACKMIDI=YES
	use alsa && LINUX_MIDIIN=ALSA
#	use portaudio && LINUX_AUDIOOUT=PA
	use mmx && ASM_F2I=YES

	local myconf="FFTW_VERSION=${FFTW_VERSION}"
	myconf="${myconf} ASM_F2I=${ASM_F2I}"
	myconf="${myconf} LINUX_MIDIIN=${LINUX_MIDIIN}"
	myconf="${myconf} LINUX_AUDIOOUT=${LINUX_AUDIOOUT}"
	myconf="${myconf} LINUX_USE_LASH=${LINUX_USE_LASH}"
	myconf="${myconf} LINUX_USE_JACKMIDI=${LINUX_USE_JACKMIDI}"

	cd "${S}/src"
	echo "make ${myconf}" > gentoo_make_options # for easier debugging
	chmod +x gentoo_make_options

	emake ${myconf} || die "make failed with this options: ${myconf}"

	cd "${S}/ExternalPrograms/Spliter"
	emake || die "emake Spliter failed"
	cd "${S}/ExternalPrograms/Controller"
	emake || die "emake Controller failed"
}

src_install() {
	dobin "${S}/src/zynaddsubfx"
	dobin "${S}/ExternalPrograms/Spliter/spliter"
	dobin "${S}/ExternalPrograms/Controller/controller"
	dodoc ChangeLog FAQ.txt HISTORY.txt README.txt ZynAddSubFX.lsm bugs.txt

	# -------- install examples presets
	[ "${#MY_PN}" == "0" ] && MY_PN="${PN}"
	insinto /usr/share/${MY_PN}/presets
	doins "${WORKDIR}/presets/"*
	insinto /usr/share/${MY_PN}/examples
	doins "${WORKDIR}/examples/"*
	# --------

	doman zynaddsubfx.1
	newicon "${S}/zynaddsubfx.xpm" "zynaddsubfx.xpm"
	make_desktop_entry "${PN}" "ZynAddSubFx-Synth" \
		"zynaddsubfx.xpm" "AudioVideo;Audio"

}

pkg_postinst() {
	einfo "Banks are now provided with the package zynaddsubfx-banks"
	einfo "To get some nice sounding parameters emerge zynaddsubfx-extras"
}