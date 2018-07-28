# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build MPCBuilder
name = "FLINT"
hash = "ea9f102a0bb8ab5fd50258aa177c345593ab11df"
version = VersionNumber("2.5.3+dev0.$(hash[1:10])")
sources = [
    "https://github.com/wbhart/flint2/archive/$hash.tar.gz" =>
    "3719310c21ebb2c6c6144f571026e4e1558847eaba7464c707484a4c33ca7356",
]

# Bash recipe for building across all platforms

script = """cd flint2-$hash
"""*raw"""
./configure --prefix=$prefix --enable-shared --disable-static --with-gmp=$prefix --with-mpfr=$prefix
make -j
make install
"""
# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:aarch64, :glibc, :blank_abi),
    BinaryProvider.Windows(:i686, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:armv7l, :glibc, :eabihf),
    BinaryProvider.Windows(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:x86_64, :glibc, :blank_abi),
    BinaryProvider.MacOS(:x86_64, :blank_libc, :blank_abi),
    BinaryProvider.Linux(:i686, :glibc, :blank_abi)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libflint", :libflint)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
    "https://github.com/JuliaMath/MPFRBuilder/releases/download/v4.0.1/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
