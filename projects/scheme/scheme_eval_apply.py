import sys

from pair import *
from scheme_utils import *
from ucb import main, trace

import scheme_forms

##############
# Eval/Apply #
##############


def scheme_eval(expr, env, _=None):  # Optional third argument is ignored
    """Evaluate Scheme expression EXPR in Frame ENV.

    >>> expr = read_line('(+ 2 2)')
    >>> expr
    Pair('+', Pair(2, Pair(2, nil)))
    >>> scheme_eval(expr, create_global_frame())
    4
    """
    # Evaluate atoms
    if scheme_symbolp(expr):
        return env.lookup(expr)
    elif self_evaluating(expr):
        return expr

    # All non-atomic expressions are lists (combinations)
    if not scheme_listp(expr):
        raise SchemeError('malformed list: {0}'.format(repl_str(expr)))
    first, rest = expr.first, expr.rest
    if scheme_symbolp(first) and first in scheme_forms.SPECIAL_FORMS:
        return scheme_forms.SPECIAL_FORMS[first](rest, env)
    else:
        # BEGIN PROBLEM 3
        "*** YOUR CODE HERE ***"
        operator = scheme_eval(first, env)
        if isinstance(operator, MacroProcedure):
            result_expr = complete_apply(operator, rest, env)
            return scheme_eval(result_expr, env)
        return scheme_apply(operator, rest.map(lambda x: scheme_eval(x, env)), env)
        # END PROBLEM 3


def scheme_apply(procedure, args, env):
    """Apply Scheme PROCEDURE to argument values ARGS (a Scheme list) in
    Frame ENV, the current environment."""
    validate_procedure(procedure)
    if not isinstance(env, Frame):
        assert False, "Not a Frame: {}".format(env)
    if isinstance(procedure, BuiltinProcedure):
        # BEGIN PROBLEM 2
        "*** YOUR CODE HERE ***"
        py_args = []
        while args != nil:
            py_args.append(args.first)
            args = args.rest
        if procedure.need_env:
            py_args.append(env)
        # END PROBLEM 2
        try:
            # BEGIN PROBLEM 2
            "*** YOUR CODE HERE ***"
            return procedure.py_func(*py_args)
            # END PROBLEM 2
        except TypeError as err:
            raise SchemeError('incorrect number of arguments: {0}'.format(procedure))
    elif isinstance(procedure, LambdaProcedure):
        # BEGIN PROBLEM 9
        "*** YOUR CODE HERE ***"
        frame = procedure.env.make_child_frame(procedure.formals, args)
        return eval_all(procedure.body, frame)
        # END PROBLEM 9
    elif isinstance(procedure, MuProcedure):
        # BEGIN PROBLEM 11
        "*** YOUR CODE HERE ***"
        frame = env.make_child_frame(procedure.formals, args)
        return eval_all(procedure.body, frame)
        # END PROBLEM 11
    elif isinstance(procedure, MacroProcedure):
        print("DEBUG: Enter scheme_apply: Macro-if")
        frame = procedure.env.make_child_frame(procedure.formals, args)
        return eval_all(procedure.body, frame)
    else:
        assert False, "Unexpected procedure: {}".format(procedure)


def eval_all(expressions, env):
    """Evaluate each expression in the Scheme list EXPRESSIONS in
    Frame ENV (the current environment) and return the value of the last.

    >>> eval_all(read_line("(1)"), create_global_frame())
    1
    >>> eval_all(read_line("(1 2)"), create_global_frame())
    2
    >>> x = eval_all(read_line("((print 1) 2)"), create_global_frame())
    1
    >>> x
    2
    >>> eval_all(read_line("((define x 2) x)"), create_global_frame())
    2
    """
    # BEGIN PROBLEM 6
    if expressions is nil:
        return None
    ptr = expressions
    while ptr.rest is not nil:
        scheme_eval(ptr.first, env)
        ptr = ptr.rest
    return scheme_eval(ptr.first, env, True)
    # END PROBLEM 6


##################
# Tail Recursion #
##################

class Unevaluated:
    """An expression and an environment in which it is to be evaluated."""

    def __init__(self, expr, env):
        """Expression EXPR to be evaluated in Frame ENV."""
        self.expr = expr
        self.env = env


def complete_apply(procedure, args, env):
    """Apply procedure to args in env; ensure the result is not an Unevaluated."""
    validate_procedure(procedure)
    val = scheme_apply(procedure, args, env)
    if isinstance(val, Unevaluated):
        return scheme_eval(val.expr, val.env)
    else:
        return val


def optimize_tail_calls(unoptimized_scheme_eval):
    """Return a properly tail recursive version of an eval function."""
    def optimized_eval(expr, env, tail=False):
        """Evaluate Scheme expression EXPR in Frame ENV. If TAIL,
        return an Unevaluated containing an expression for further evaluation.
        """
        if tail and not scheme_symbolp(expr) and not self_evaluating(expr):
            return Unevaluated(expr, env)

        result = Unevaluated(expr, env)
        # BEGIN PROBLEM EC
        "*** YOUR CODE HERE ***"
        while isinstance(result, Unevaluated):
            result = unoptimized_scheme_eval(result.expr, result.env)
        return result
        # END PROBLEM EC
    return optimized_eval


################################################################
# Uncomment the following line to apply tail call optimization #
################################################################

scheme_eval = optimize_tail_calls(scheme_eval)


# From Disc 12
"""Tail-call optimization can be implemented in a few ways:
Instead of creating a new frame, the interpreter can just update the values of the relevant variables 
in the current frame (like n and result for the fact-tail procedure). 
It reuses the same frame for the entire calculation, 
constantly changing the bindings to match the next set of parameters.

How our 61A Scheme interpreter works: 
The interpreter builds a new frame as usual, but then replaces the current frame with the new one. 
The old frame is still around, but the interpreter no longer has any way to get to it. 
When that happens, the Python interpreter does something clever: 
it recycles the old frame so that the next time a new frame is needed, 
the system simply allocates it out of recycled space. 
The technical term is that the old frame becomes "garbage", 
which the system "garbage collects" behind the programmer's back.
"""
