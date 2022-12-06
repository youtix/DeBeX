// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import { IERC173 } from "../interfaces/IERC173.sol";
import { LibOwnable } from "../libraries/LibOwnable.sol";

contract OwnershipFacet is IERC173 {

    function owner() public view returns (address) {
        return LibOwnable._owner();
    }

    function transferOwnership(address newOwner) public {
        LibOwnable._revertIfNotOwner();
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        LibOwnable._transferOwnership(newOwner);
    }
}
