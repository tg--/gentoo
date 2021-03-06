# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool allowing incremental and recursive IMAP transfers between mailboxes"
HOMEPAGE="http://ks.lamiral.info/imapsync/ https://github.com/imapsync/imapsync"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	dev-lang/perl"

RDEPEND="
	${DEPEND}
	dev-perl/Digest-HMAC
	dev-perl/File-Copy-Recursive
	dev-perl/IO-Socket-INET6
	dev-perl/IO-Socket-SSL
	dev-perl/IO-Tee
	dev-perl/Mail-IMAPClient
	dev-perl/Readonly
	dev-perl/Sys-MemInfo
	dev-perl/TermReadKey
	dev-perl/Unicode-String
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64"

RESTRICT="test"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	sed -e "s/^install: testp/install:/" \
		-e "/^DO_IT/,/^$/d" \
		-i "${S}"/Makefile || die

	default
}

src_compile() { :; }
