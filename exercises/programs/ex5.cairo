from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.math import abs_value

// Implement a funcion that returns:
// - 1 when magnitudes of inputs are equal
// - 0 otherwise
func abs_eq{range_check_ptr}(x: felt, y: felt) -> (bit: felt) {
    let x_abs = abs_value(x);
    let y_abs = abs_value(y);
    tempvar diff = abs_value(x_abs - y_abs);

    let is_less = is_le(diff, 10);
    
    if(is_less == 1) {
        return (bit=1);
    }
    
    return (bit=0);
}
