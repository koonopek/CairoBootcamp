%lang starknet
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_le,
    uint256_unsigned_div_rem,
    uint256_sub,
    uint256_mul,
)
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt
from starkware.cairo.common.math import (
    assert_not_zero,
    assert_not_equal,
    assert_nn,
    assert_le,
    assert_lt,
    assert_in_range,
)
from exercises.contracts.erc20.ERC20_base import (
    ERC20_name,
    ERC20_symbol,
    ERC20_totalSupply,
    ERC20_decimals,
    ERC20_balanceOf,
    ERC20_allowance,
    ERC20_mint,
    ERC20_initializer,
    ERC20_transfer,
    ERC20_burn,
)

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    name: felt, symbol: felt, initial_supply: Uint256, recipient: felt
) {
    ERC20_initializer(name, symbol, initial_supply, recipient);
    admin.write(recipient);
    return ();
}

// Storage
//#########################################################################################

@storage_var
func admin() -> (name: felt) {
}

@storage_var
func whitelist(address: felt) -> (is: felt) {
}

// View functions
//#########################################################################################

@view
func name{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (name: felt) {
    let (name) = ERC20_name();
    return (name,);
}

@view
func get_admin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    admin_address: felt
) {
    let (admin_address) = admin.read();
    return (admin_address,);
}
@view
func symbol{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (symbol: felt) {
    let (symbol) = ERC20_symbol();
    return (symbol,);
}

@view
func totalSupply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    totalSupply: Uint256
) {
    let (totalSupply: Uint256) = ERC20_totalSupply();
    return (totalSupply,);
}

@view
func decimals{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    decimals: felt
) {
    let (decimals) = ERC20_decimals();
    return (decimals,);
}

@view
func balanceOf{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(account: felt) -> (
    balance: Uint256
) {
    let (balance: Uint256) = ERC20_balanceOf(account);
    return (balance,);
}

@view
func allowance{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    owner: felt, spender: felt
) -> (remaining: Uint256) {
    let (remaining: Uint256) = ERC20_allowance(owner, spender);
    return (remaining,);
}

// Externals
//###############################################################################################

@external
func transfer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*,range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
    recipient: felt, amount: Uint256
) -> (success: felt) {
    alloc_locals;
    let (local is_even_hex) = bitwise_and(amount.low, 0x01);

    with_attr error_message("ERC20: amount is not even") {
        assert is_even_hex = 0x00;
    }

    ERC20_transfer(recipient, amount);    
    
    return (1,);
}

@external
func faucet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: Uint256) -> (
    success: felt
) {
    let (caller) = get_caller_address();

    let (is_le) = uint256_le(amount, Uint256(10000,0));
    with_attr error_message("ERC20: too big amount") {
        assert is_le = 1;
    }
        
    ERC20_mint(caller, amount);
    return (1,);
}

@external
func burn{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(amount: Uint256) -> (
    success: felt
) {
    alloc_locals;
    let div = Uint256(10,0);
    let (local fee, rem) = uint256_unsigned_div_rem(amount, div);
 
    let (to) = admin.read();
    ERC20_transfer(to, fee);
    
    let (rest) = uint256_sub(amount, fee);
      
    let (caller) = get_caller_address();
    ERC20_burn(caller, rest);

    return (1,);
}

@external
func request_whitelist{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    level_granted: felt
) {
    let (caller) = get_caller_address();
    whitelist.write(caller, 1);

    return (level_granted=1,);
}

@external
func check_whitelist{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    account: felt
) -> (allowed_v: felt) {
    let (is) = whitelist.read(account);

    return (allowed_v=is,);
}

@external
func exclusive_faucet{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    amount: Uint256
) -> (success: felt) {
    alloc_locals;

    let (local caller) = get_caller_address();
    let (local is_whitelisted) = check_whitelist(caller); 

    if(is_whitelisted == 1) {
         ERC20_mint(caller, amount);
         tempvar syscall_ptr = syscall_ptr;
         tempvar pedersen_ptr= pedersen_ptr;
         tempvar range_check_ptr= range_check_ptr;
    } else {
         let (local result) = faucet(amount);
         assert result = 1;
         tempvar syscall_ptr = syscall_ptr;
         tempvar pedersen_ptr= pedersen_ptr;
         tempvar range_check_ptr= range_check_ptr;
    }

    return (success=1);
}

