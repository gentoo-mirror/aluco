# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit toolchain-funcs

DESCRIPTION="GTK-based GUI to configure a space navigator device"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/spacenav/spacenavd%20config%20gui/${PN}%20${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	sys-libs/spacenavd"

src_prepare() {
	rm configure || die
	mv Makefile{.in,} || die
}

src_compile() {
	# TODO Improve build system upstream
	emake CFLAGS="${CFLAGS} $(pkg-config --cflags gtk+-2.0)" \
			LDFLAGS="${LDFLAGS} $(pkg-config --libs gtk+-2.0)" \
			CC=$(tc-getCC) \
		|| die
}

src_install() {
	emake PREFIX="${D}/usr" install || die
}
