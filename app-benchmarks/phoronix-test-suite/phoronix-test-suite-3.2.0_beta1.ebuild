# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/phoronix-test-suite/phoronix-test-suite-3.2.1_beta1.ebuild,v 1.0 2011/04/22 21:49:19 abourgeois Exp $

EAPI=4

inherit eutils bash-completion

DESCRIPTION="Phoronix's comprehensive, cross-platform testing and benchmark suite"
HOMEPAGE="http://www.phoronix-test-suite.com"
MY_PV="${PN}-3.2.0m1"
SRC_URI="http://www.phoronix-test-suite.com/download.php?file=development/${MY_PV} -> ${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND=""

# php 5.3 doesn't have pcre and reflection useflags anymore
# php-gtk doesn't support php 5.3 at once
RDEPEND="|| ( dev-lang/php:5.3[cli,curl,gd,posix,pcntl,truetype,zip] dev-lang/php:5.2[cli,curl,gd,posix,pcntl,reflection,truetype,pcre,zip] )
		dev-php5/pecl-ps
		gtk? ( dev-php5/php-gtk )"

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
	dobashcompletion pts-core/static/bash_completion ${PN}
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

	# Need to fix the cli-php config for downloading to work. Very naughty!
	dodir /etc/php/cli-php5.2
	cp /etc/php/cli-php5.2/php.ini "${D}/etc/php/cli-php5.2/php.ini"
	sed -e 's|^allow_url_fopen .*|allow_url_fopen = On|g' -i "${D}/etc/php/cli-php5.2/php.ini"
}
