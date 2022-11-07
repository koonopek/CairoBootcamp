%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le

// Using binary operations return:
// - 1 when pattern of bits is 01010101 from LSB up to MSB 1, but accounts for trailing zeros
// - 0 otherwise

// 000000101010101 PASS
// 010101010101011 FAIL

func pattern{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    n: felt, idx: felt, exp: felt, broken_chain: felt
) -> (true: felt) {
    alloc_locals;
    
    // let fixed_n = get_n(n,idx); << doesnt work 
    let cos = get_n(n, idx);
    local fixed_n = cos;
     
    let bit = get_bit(idx);

    let is_bigger = is_le(idx,fixed_n);
    if(is_bigger == 0) {
        return (true=broken_chain);
    }

    let (match) = bitwise_and(fixed_n,bit);    
    
    if (match == bit) {
        return pattern(fixed_n,bit * 4, 0, 1);
    } else {
        return (0,);
    }
}

func get_bit(idx: felt) -> felt {
    if(idx == 0) {
        return 2;
    } else {
        return idx;
    }
}

func get_n{bitwise_ptr: BitwiseBuiltin*}(n: felt, idx: felt) -> felt {
    if(idx == 0) {
        let (is_even_hex) = bitwise_and(n, 0x01);

        if (is_even_hex == 0x00) {
            return n;
        }
        
        return n * 2;
    } else {
        return n;
    }
}