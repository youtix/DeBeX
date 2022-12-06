// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import { IDiamondCut } from "../interfaces/IDiamondCut.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";
import { LibOwnable } from "../libraries/LibOwnable.sol";

contract DiamondCutFacet is IDiamondCut {
    
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {
        LibOwnable._revertIfNotOwner();
        LibDiamond.diamondCut(_diamondCut, _init, _calldata);
    }
}
