# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Package used for parsing and generating iCalendar files (RFC 2445)"
HOMEPAGE="
	https://github.com/collective/icalendar/
	https://pypi.org/project/icalendar/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/tzdata[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-copybutton \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest

python_prepare_all() {
	# reset conf.py to not read version from an installed instance
	sed -e "s:pkg_resources.get_distribution('icalendar').version:'${PV}':" \
		-i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
