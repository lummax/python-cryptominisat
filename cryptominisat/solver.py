import cryptominisat._cryptominisat as cm

class Solver:
    def __init__(self, num_threads=None, allow_otf_gauss=None, max_confl=None,
                 verbosity=None, default_polarity=None, no_simplify=None,
                 no_simplify_at_startup=None, no_equivalent_lit_replacement=None,
                 no_bva=None, greedy_undef=None, independent_vars=None,
                 timeout_all_calls=None):
        self._solver = cm.Solver()

        if num_threads is not None:
            if num_threads < 1: raise ValueError("num_threads to small")
            self._solver.set_num_threads(num_threads)
        if allow_otf_gauss is not None:
            self._solver.set_allow_otf_gauss()
        if max_confl is not None:
            if max_confl < 0: raise ValueError("max_conf to small")
            self._solver.set_max_confl(max_confl)
        if verbosity is not None:
            if verbosity < 0: raise ValueError("verbosity to small")
            self._solver.set_verbosity(verbosity)
        if default_polarity is not None:
            self._solver.set_default_polarity(default_polarity)
        if no_simplify is not None:
            self._solver.set_no_simplify()
        if no_simplify_at_startup is not None:
            self._solver.set_no_simplify_at_startup()
        if no_equivalent_lit_replacement is not None:
            self._solver.set_no_equivalent_lit_replacement()
        if no_bva is not None:
            self._solver.set_no_bva()
        if greedy_undef is not None:
            self._solver.set_greedy_undef()
        if independent_vars is not None:
            self._solver.set_independent_vars(independent_vars)
        if timeout_all_calls is not None:
            self._solver.set_timeout_all_calls(timeout_all_calls)
            self.timeout_all_calls = timeout_all_calls
        else:
            self.timeout_all_calls = -1

    def _ensure_number_of_variables(self, clause):
        max_var = max(abs(c) for c in clause)
        if max_var > self._solver.number_of_vars:
            self._solver.new_vars(max_var - self._solver.number_of_vars)

    def add_clause(self, clause):
        if any(c == 0 for c in clause):
            raise ValueError("`clause` must be a list of non-zero integers")

        self._ensure_number_of_variables(clause)
        return self._solver.add_clause(clause)

    def add_xor_clause(self, clause, rhs):
        if any(c <= 0 for c in clause):
            raise ValueError("`cause` mut be a list of positive integers")

        self._ensure_number_of_variables(clause)
        return self._solver.add_xor_clause(clause, rhs)

    def solve(self, assumptions=None, timeout=None):
        max_var = self._solver.number_of_vars
        if assumptions and any(c == 0 or abs(c) > max_var for c in assumptions):
            raise ValueError("`assumptions` must be a list of non-zero integers" + \
                             " where every literal is known to the solver")

        self._solver.set_timeout_all_calls(timeout or self.timeout_all_calls)
        sat = self._solver.solve(assumptions or [])

        if sat is True:
            model = (None, ) + self._solver.get_model()
            return (sat, model)
        if sat is False:
            return (sat, ())
        return (None, None)

    def simplify(self, assumptions=None):
        max_var = self._solver.number_of_vars
        if assumptions and any(c == 0 or abs(c) > max_var for c in assumptions):
            raise ValueError("`assumptions` must be a list of non-zero integers" + \
                             " where every literal is known to the solver")
        return self._solver.simplify(assumptions or [])

    def okay(self):
        return self._solver.okay()
