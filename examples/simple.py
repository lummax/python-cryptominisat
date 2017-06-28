#!/usr/bin/env python3

import cryptominisat

def main():
    solver = cryptominisat.Solver()

    solver.add_clause([1, -5, 4])
    solver.add_clause([-1, 5, 3, 4])
    solver.add_clause([-3, -4])

    (sat, solution) = solver.solve()
    assert sat
    print(solution)
    assert solver.okay()


if __name__ == '__main__':
    main()
