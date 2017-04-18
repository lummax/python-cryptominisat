#!/usr/bin/env python3

from distutils.core import setup
from distutils.extension import Extension

try: from Cython.Build import cythonize
except ImportError: USE_CYTHON = False
else: USE_CYTHON = True

source = "cryptominisat/_cryptominisat." + ("pyx" if USE_CYTHON else "cpp")
extensions = [Extension("cryptominisat._cryptominisat",
                        [source],
                        libraries=["cryptominisat5"],
                        include_dirs = ["."],
                        language="c++",
                        extra_compile_args=["-std=c++11"],
                        extra_link_args=["-std=c++11"])]


setup(name = "cryptominisat",
      version = "0.1-501",
      license = "MIT",
      description = "Python 2/3 bindings to the `cryptominisat5` SAT solver",
      url = "https://github.com/lummax/python-cryptominisat",
      packages = ["cryptominisat"],
      ext_modules = cythonize(extensions) if USE_CYTHON else extensions,
      package_data = {"cryptominisat": ["*.pyx", "*.pxd"]})
