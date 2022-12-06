// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import { LibPausable } from "../libraries/LibPausable.sol";
import { LibOwnable } from "../libraries/LibOwnable.sol";
import { IPausable } from "../interfaces/IPausable.sol";

contract PausableFacet is IPausable {

    function paused() public view returns (bool) {
        return LibPausable.getStorage()._paused;
    }

    function pause() public {
        LibOwnable._revertIfNotOwner();
        LibPausable._revertIfPaused();
        LibPausable._pause();
    }

    function unpause() public {
        LibOwnable._revertIfNotOwner();
        LibPausable._revertIfUnpaused();
        LibPausable._unpause();
    }
}
