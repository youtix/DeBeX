// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

import { IBlacklistable } from "../interfaces/IBlacklistable.sol";
import { LibBlacklistable } from "../libraries/LibBlacklistable.sol";

contract BlacklistableFacet is IBlacklistable {

    function isBlacklisted(address _account) public view returns (bool) {
        return LibBlacklistable.getStorage()._blacklisted[_account];
    }

    function blacklist(address _account) public {
        LibBlacklistable._revertIfNotBlacklister();
        LibBlacklistable._blacklist(_account);
    }

    function unBlacklist(address _account) public {
        LibBlacklistable._revertIfNotBlacklister();
        LibBlacklistable._unblacklist(_account);
    }
    
    function updateBlacklister(address _newBlacklister) public {
        LibBlacklistable._revertIfNotBlacklister();
        LibBlacklistable._updateBlacklister(_newBlacklister);
    }
}
