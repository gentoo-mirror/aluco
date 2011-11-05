# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# 

EAPI=2
inherit eutils toolchain-funcs cmake-utils games

MY_P="${PN}-v${PV}"

DESCRIPTION="GeneticInvasion is a tower defence game under a free license."
HOMEPAGE="http://projects.haxx.es/p/genetic-invasion/"
SRC_URI="http://projects.haxx.es/media/upload/genetic-invasion/files/${MY_P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=media-libs/libsfml-1.6*
=sci-libs/eo-1.2.0*
virtual/glu"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# disable app building since they're broken
	sed -i \
		-e 's?CMAKE_INSTALL_PREFIX}/share/geneticinvasion?CMAKE_INSTALL_PREFIX}/genetic-invasion?' \
		"${S}/CMakeLists.txt"

}

src_configure() {
	local mycmakeargs="-D CMAKE_INSTALL_PREFIX:PATH=${GAMES_DATADIR}"
	cmake-utils_src_configure || die "cmake-utils_src_configure failed"
}

src_compile() {
	cmake-utils_src_compile || die "cmake-utils_src_compile failed"
}

src_install() {
	dodir "${GAMES_BINDIR}" "${GAMES_DATADIR}/${PN}/data"
	dogamesbin "${CMAKE_BUILD_DIR}"/bin/GeneticInvasion

	insinto "${GAMES_DATADIR}/${PN}/data"
	doins -r "${S}"/data/* || die "doins failed"
	insinto "${GAMES_DATADIR}/${PN}"
	dodoc "${S}"/ToDo || die "dodoc failed"

	prepgamesdirs
}
