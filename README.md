`python-cryptominisat` [![Build Status](https://travis-ci.org/lummax/python-cryptominisat.svg?branch=master)](https://travis-ci.org/lummax/python-cryptominisat)
==============================

Python 2/3 bindings
to [`cryptominisat5`](https://github.com/msoos/cryptominisat)
using [`Cython`](http://cython.org/). These were started before the in-tree
cryptominisat Python bindings got implemented.

Usage
-----

```
import cryptominisat

solver = cryptominisat.Solver()

solver.add_clause([1, -5, 4])
solver.add_clause([-1, 5, 3, 4])
solver.add_clause([-3, -4])

(sat, solution) = solver.solve()
```

With [`virtualenv`](https://virtualenv.pypa.io/en/stable/)
----------------------------------------------------------

Please make sure to
have [`cryptominisat`](https://github.com/msoos/cryptominisat) installed.

```
virtualenv .env
source .env/bin/activate
unset SOURCE_DATE_EPOCH  # might be necessary
pip install Cython
pip install .
python3 -m unittest
./examples/simple.py
```

With [`nix-shell`](http://nixos.org/nix/manual/#sec-nix-shell)
--------------------------------------------------------------

```
nix-shell --attr python-cryptominisat
python3 -m unittest
./examples/simple.py
```
