// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import { LibDiamond } from "./libraries/LibDiamond.sol";
import { LibPausable } from "./libraries/LibPausable.sol";
import { LibOwnable } from "./libraries/LibOwnable.sol";
import { LibBlacklistable } from "./libraries/LibBlacklistable.sol";
import { IDiamondCut } from "./interfaces/IDiamondCut.sol";
import { IDiamondLoupe } from  "./interfaces/IDiamondLoupe.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165} from "./interfaces/IERC165.sol";
import { IPausable} from "./interfaces/IPausable.sol";
import { IBlacklistable} from "./interfaces/IBlacklistable.sol";

error FunctionNotFound(bytes4 _functionSelector);

struct DiamondArgs {
    address owner;
    address init;
    bytes initCalldata;
}

contract Diamond {    

    constructor(IDiamondCut.FacetCut[] memory _diamondCut, DiamondArgs memory _args) payable {
        
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
        ds.supportedInterfaces[type(IPausable).interfaceId] = true;
        ds.supportedInterfaces[type(IBlacklistable).interfaceId] = true;

        LibOwnable._transferOwnership(_args.owner);
        LibPausable._pause();
        LibBlacklistable._updateBlacklister(_args.owner);
        LibDiamond.diamondCut(_diamondCut, _args.init, _args.initCalldata);
    }

    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        // get diamond storage
        assembly {
            ds.slot := position
        }
        // get facet from function selector
        address facet = ds.facetAddressAndSelectorPosition[msg.sig].facetAddress;
        if(facet == address(0)) {
            revert FunctionNotFound(msg.sig);
        }
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
             // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
                case 0 {
                    revert(0, returndatasize())
                }
                default {
                    return(0, returndatasize())
                }
        }
    }

    receive() external payable {}
}
