from libcpp.vector cimport vector
from libcpp.limits cimport numeric_limits
from cpython cimport bool as Bool
from cython.operator cimport dereference as deref

cdef class Solver:
    cdef SATSolver* _solver

    def __cinit__(self):
        self._solver = new SATSolver(NULL, NULL)

    def __dealloc__(self):
        del self._solver

    @property
    def number_of_vars(self):
        return self._solver.nVars()

    def set_num_threads(self, unsigned number):
        self._solver.set_num_threads(number)

    def set_allow_otf_gauss(self):
        self._solver.set_allow_otf_gauss()

    def set_max_confl(self, int64_t max_confl):
        self._solver.set_max_confl(max_confl)

    def set_verbosity(self, unsigned verbosity=0):
        self._solver.set_verbosity(verbosity)

    def set_default_polarity(self, bool polarity):
        self._solver.set_default_polarity(polarity)

    def set_no_simplify(self):
        self._solver.set_no_simplify()

    def set_no_simplify_at_startup(self):
        self._solver.set_no_simplify_at_startup()

    def set_no_equivalent_lit_replacement(self):
        self._solver.set_no_equivalent_lit_replacement()

    def set_no_bva(self):
        self._solver.set_no_bva()

    def set_greedy_undef(self):
        self._solver.set_greedy_undef()

    def set_independent_vars(self, vector[uint32_t]& ind_vars):
        self._solver.set_independent_vars(&ind_vars)

    def set_timeout_all_calls(self, double secs):
        if secs > 0:
            self._solver.set_timeout_all_calls(secs)
        else:
            self._solver.set_timeout_all_calls(numeric_limits[double].max())

    cdef vector[Lit] _to_literals(self, vector[int]& clause):
        cdef vector[Lit] literals = vector[Lit]()
        for var in clause:
            literals.push_back(Lit(abs(var) - 1, var < 0))
        return literals

    cdef Bool _from_lbool(self, lbool value):
        if value.getValue() == 0:
            return True
        if value.getValue() == 1:
            return False
        return None

    def new_var(self):
        self._solver.new_var()

    def new_vars(self, size_t number):
        self._solver.new_vars(number)

    def add_clause(self, vector[int]& clause):
        return self._solver.add_clause(self._to_literals(clause))

    def add_xor_clause(self, vector[unsigned int]& clause, bool rhs):
        return self._solver.add_xor_clause((c - 1 for c in clause), rhs)

    def solve(self, vector[int]& assumptions):
        cdef lbool result = lbool();
        if assumptions.empty():
            with nogil:
                result = self._solver.solve(NULL)
            return self._from_lbool(result)

        cdef vector[Lit] literals = self._to_literals(assumptions)
        with nogil:
            result = self._solver.solve(&literals)
        return self._from_lbool(result)

    def simplify(self, vector[int]& assumptions):
        if assumptions.empty():
            return self._from_lbool(self._solver.simplify(NULL))

        cdef vector[Lit] literals = self._to_literals(assumptions)
        return self._from_lbool(self._solver.simplify(&literals))

    def get_model(self):
        cdef vector[lbool] model = self._solver.get_model()
        return tuple(self._from_lbool(m) for m in model)

    def get_conflict(self):
        cdef vector[Lit] conflict = self._solver.get_conflict()
        corrected = ((c.sign(), c.var() + 1) for c in conflict)
        return tuple(-var if sign else var for (sign, var) in corrected)

    def okay(self):
        return self._solver.okay()
