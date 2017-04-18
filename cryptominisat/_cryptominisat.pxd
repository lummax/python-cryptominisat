from libcpp.pair cimport pair
from libcpp.string cimport string
from libcpp.vector cimport vector

from libcpp cimport bool
from libc.stdint cimport (uint8_t, uint32_t, int64_t)

cdef extern from "<atomic>" namespace "std" nogil:
    cdef cppclass atomic[T]:
        atomic() except +

cdef extern from "<cryptominisat5/solvertypesmini.h>" namespace "CMSat" nogil:
    cdef cppclass Lit:
        Lit() except +
        Lit(uint32_t var, bool is_inverted) except +
        bool sign() const
        uint32_t var() const

    cdef cppclass lbool:
        lbool() except +
        lbool(uint8_t v) except +
        uint8_t getValue()

cdef extern from "<cryptominisat5/cryptominisat.h>" namespace "CMSat" nogil:
    cdef cppclass SATSolver:
        SATSolver(void* config, void* interrupt_asap) except +
        unsigned nVars() const
        bool add_clause(const vector[Lit]& lits)
        bool add_xor_clause(const vector[unsigned]& vars, bool rhs)
        void new_var()
        void new_vars(const size_t n)
        lbool solve(const vector[Lit]* assumptions)
        lbool simplify(const vector[Lit]* assumptions)
        const vector[lbool]& get_model() const
        const vector[Lit]& get_conflict() const
        bool okay() const
        void log_to_file(string filename)

        void set_num_threads(unsigned n)
        void set_allow_otf_gauss()
        void set_max_confl(int64_t max_confl)
        void set_verbosity(unsigned verbosity)
        void set_default_polarity(bool polarity)
        void set_no_simplify()
        void set_no_simplify_at_startup()
        void set_no_equivalent_lit_replacement()
        void set_no_bva()
        void set_greedy_undef()
        void set_independent_vars(vector[uint32_t]* ind_vars)
        void set_timeout_all_calls(double secs)

        @staticmethod
        const char* get_version()
        @staticmethod
        const char* get_version_sha1()
        @staticmethod
        const char* get_compilation_env()

        void print_stats() const
        #void set_drat(ostream* os, bool set_ID)
        void interrupt_asap()
        void open_file_and_dump_irred_clauses(string fname) const
        void open_file_and_dump_red_clauses(string fname) const
        void add_in_partial_solving_stats()

        vector[Lit] get_zero_assigned_lits() const
        vector[pair[Lit, Lit]] get_all_binary_xors() const

cdef lbool l_True  = lbool(0)
cdef lbool l_False = lbool(1)
cdef lbool l_Undef = lbool(2)

cdef var_Undef = (0xffffffffU >> 4)
cdef Lit lit_Undef = Lit(var_Undef, False)
cdef Lit lit_Error = Lit(var_Undef, True)
