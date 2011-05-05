# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils bash-completion

DESCRIPTION="Phoronix's comprehensive, cross-platform testing and benchmark suite"
HOMEPAGE="http://www.phoronix-test-suite.com"
MY_PV="${PN}-3.2.0m2"
SRC_URI="http://www.phoronix-test-suite.com/download.php?file=development/${MY_PV} -> ${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND=""

# php 5.3 doesn't have pcre and reflection useflags anymore
# php-gtk doesn't support php 5.3 at once
RDEPEND="!gtk? ( || ( dev-lang/php:5.3[cli,curl,gd,posix,pcntl,truetype,zip] dev-lang/php:5.2[cli,curl,gd,posix,pcntl,reflection,truetype,pcre,zip] ) )
		gtk? ( dev-lang/php:5.2[cli,curl,gd,posix,pcntl,reflection,truetype,pcre,zip]
			dev-php5/php-gtk )
		dev-php5/pecl-ps"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i -e "s,export PTS_DIR=\`pwd\`,export PTS_DIR=\"/usr/share/${PN}\"," \
		phoronix-test-suite
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir /usr/share/${PN}
	insinto /usr/share/${PN}

	doman documentation/man-pages/phoronix-test-suite.1
	dodoc AUTHORS CHANGE-LOG COPYING documentation/phoronix-test-suite.pdf
	dohtml -r documentation/
	doicon pts-core/static/images/phoronix-test-suite.png
	doicon pts-core/static/images/openbenchmarking.png
	domenu pts-core/static/phoronix-test-suite.desktop
	rm -f pts-core/static/phoronix-test-suite.desktop

	doins -r {pts,pts-core}
	exeinto /usr/bin
	doexe phoronix-test-suite

	#fperms a+x /usr/share/${PN}/pts/test-resources/*/*.sh
	#fperms a+x /usr/share/${PN}/pts/base-test-resources/*/*.sh
	#fperms a+x /usr/share/${PN}/pts-core/modules/*.sh
	#fperms a+x /usr/share/${PN}/pts-core/test-libraries/*.sh
	fperms a+x /usr/share/${PN}/pts-core/static/scripts/root-access.sh
	fperms a+x /usr/share/${PN}/pts-core/external-test-dependencies/scripts/install-gentoo-packages.sh

	dobashcompletion pts-core/static/bash_completion ${PN}

	# Need to fix the cli-php config for downloading to work. Very naughty!
	local slots
	local slot
	if use gtk ; then
		slots="php5.2"
	else
		if [[ "x${PHP_TARGETS}" == "x" ]] ; then
			ewarn
			ewarn "PHP_TARGETS seems empty, php.ini file can't be configure."
			ewarn "Make sure that PHP_TARGETS in /etc/make.conf is set."
			ewarn
		else
			for slot in ${PHP_TARGETS}; do
				slots+=" ${slot/-/.}"
			done
		fi
	fi

	for slot in ${slots}; do
		local PHP_INI_FILE="/etc/php/cli-${slot}/php.ini"
		if [[ -f ${PHP_INI_FILE} ]] ; then
			dodir $(dirname ${PHP_INI_FILE})
			cp ${PHP_INI_FILE} "${D}${PHP_INI_FILE}"
			sed -e 's|^allow_url_fopen .*|allow_url_fopen = On|g' -i "${D}${PHP_INI_FILE}"
		else
			if [[ "x$(eselect php show cli)" == "x${slot}" ]] ; then
				ewarn
				ewarn "${slot} hasn't a php.ini file."
				ewarn "phoronix-test-suite needs the allow_url_fopen option set to \"On\""
				ewarn "for downloading to work properly."
				ewarn "Check that your PHP_INI_VERSION is set during ${slot} merge"
				ewarn
			else
				einfo
				einfo "${slot} hasn't a php.ini file."
				einfo "phoronix-test-suite may need the allow_url_fopen option set to \"On\""
				einfo "for downloading to work properly if you switch to ${slot}"
				einfo "Check that your PHP_INI_VERSION is set during ${slot} merge"
				einfo
			fi
		fi
	done
}
