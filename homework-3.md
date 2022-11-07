1. `output_ptr` is buitlin used by `seralize_word` function, it is propably pointing to some space in memory in which variables to be outputted are stored.
`
  func square{output_ptr: felt*}(x: felt) -> (y: felt) {
        return (y= x*x);
        }
  }
`