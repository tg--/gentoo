# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module perl-module

DESCRIPTION="Advanced command-line tools to perform a variety of MySQL and system tasks"
HOMEPAGE="https://www.percona.com/software/mysql-tools/percona-toolkit"
SRC_URI="https://www.percona.com/downloads/${PN}/${PV}/source/tarball/${P}.tar.gz
	https://github.com/hydrapolic/gentoo-dist/releases/download/${P}/${P}-deps.tar.xz"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="amd64 x86"
# Package warrants IUSE doc
IUSE=""

COMMON_DEPEND="dev-perl/DBI
	dev-perl/DBD-mysql
	virtual/perl-Time-HiRes"
RDEPEND="${COMMON_DEPEND}
	dev-perl/JSON
	dev-perl/Role-Tiny
	dev-perl/TermReadKey
	dev-perl/libwww-perl
	virtual/perl-Digest-MD5
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-IO-Compress
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-Local"
DEPEND="${COMMON_DEPEND}
	virtual/perl-ExtUtils-MakeMaker"

# Bug #501904 - CVE-2014-2029
# sed -i -e '/^=item --\[no\]version-check/,/^default: yes/{/^default: yes/d}' bin/*
# ^ is *-no-versioncheck.patch
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.7-no-versioncheck.patch
	"${FILESDIR}"/${PN}-3.0.10-slave-delay-fix.patch
)

src_install() {
	default
	dobin bin/*
}
