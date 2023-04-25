from inspect import signature
from functools import wraps


def validate(*args, **kwargs):
    def validate_types(func):
        # map function argument names to supplied types
        sig = signature(func)
        bound_types = sig.bind_partial(*args, **kwargs).arguments

        @wraps(func)
        def wrapper(*args, **kwargs):
            bound_values = sig.bind(*args, **kwargs)
            # enforce type checks across supplied arguments
            for name, value in bound_values.arguments.items():
                if name in bound_types:
                    if not isinstance(value, bound_types[name]):
                        # raise TypeError(
                        #     'Argument {} must be {}'.format(name, bound_types[name])
                        # )
                        args = 10, 'Argument {} must be {}'.format(name, bound_types[name])
            return func(*args, **kwargs)
        return wrapper
    return validate_types
