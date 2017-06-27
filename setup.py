import unittest
from setuptools import setup
from setuptools.extension import Extension

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

def tests():
    test_loader = unittest.TestLoader()
    return test_loader.discover('.')


setup(name = "cryptominisat",
      version = "0.1-501",
      license = "MIT",
      description = "Python 2/3 bindings to the `cryptominisat5` SAT solver",
      classifiers = [
          "Programming Language :: Python :: 2",
          "Programming Language :: Python :: 2.7",
          "Programming Language :: Python :: 3",
          "Programming Language :: Python :: 3.3",
          "Programming Language :: Python :: 3.4",
          "Programming Language :: Python :: 3.5",
          "Programming Language :: Python :: 3.6",
          "License :: OSI Approved :: MIT License",
          "Topic :: Utilities",
      ],
      url = "https://github.com/lummax/python-cryptominisat",
      packages = ["cryptominisat"],
      ext_modules = cythonize(extensions) if USE_CYTHON else extensions,
      package_data = {"cryptominisat": ["*.pyx", "*.pxd"]},
      test_suite='setup.tests')
