# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="The libspnav provides a replacement of the magellan library with cleaner and more orthogonal API."
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/spacenav/spacenav%20library%20%28SDK%29/libspnav%20${PV}/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-custom-flags.patch
}

src_configure() {
	econf \
		--enable-opt --enable-ldopt \
		$(use_enable X x11) \
		$(use_enable debug)
}
