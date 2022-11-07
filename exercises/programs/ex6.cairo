from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

// Implement a function that sums even numbers from the provided array
func sum_even{bitwise_ptr: BitwiseBuiltin*}(arr_len: felt, arr: felt*, run: felt, idx: felt) -> (
    sum: felt
) {

    if (idx == arr_len) {
        return (sum=run);
    }
    
    let elem = arr[idx];
    let (is_even_hex) = bitwise_and(elem, 0x01);

    if (is_even_hex == 0x00) {
        let new_idx = idx + 1;
        return sum_even(arr_len, arr, run + elem, new_idx);
    } else {
        let new_idx = idx + 1;
        return sum_even(arr_len, arr, run, new_idx);
    }
}
