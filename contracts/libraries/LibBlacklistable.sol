// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

library LibBlacklistable {

    bytes32 constant BLACKLIST_POSITION = keccak256("debex.blacklist.storage");
    struct BlacklistStorage {
        address _blacklister;
        mapping(address => bool) _blacklisted;
    }
    function getStorage() internal pure returns (BlacklistStorage storage pausableStorage) {
        bytes32 position = BLACKLIST_POSITION;
        assembly {
            pausableStorage.slot := position
        }
    }

    /// @notice Emitted when an account is blacklisted.
    event Blacklisted(address indexed _account);
    /// @notice Emitted when the pause is lifted by `account`.
    event UnBlacklisted(address indexed _account);
    /// @notice Emitted when the pause is lifted by `account`.
    event BlacklisterChanged(address indexed newBlacklister);

    /// @notice Revert if sender is blacklisted
    function _revertIfBlacklisted() internal view {
        BlacklistStorage storage _storage = getStorage();
        require(!_storage._blacklisted[msg.sender], "Blacklistable: account is blacklisted");
    }

    /// @notice Revert if sender is not the blacklister
    function _revertIfNotBlacklister() internal view {
        BlacklistStorage storage _storage = getStorage();
        require(msg.sender == _storage._blacklister, "Blacklistable: caller is not the blacklister");
    }

    /// @notice Update the blacklister
    function _updateBlacklister(address _newBlacklister) internal {
        require(_newBlacklister != address(0), "Blacklistable: new blacklister is the zero address");
        BlacklistStorage storage _storage = getStorage();
        _storage._blacklister = _newBlacklister;
        emit BlacklisterChanged(_storage._blacklister);
    }

    /// @notice Blacklist an account
    function _blacklist(address _account) internal {
        getStorage()._blacklisted[_account] = true;
        emit Blacklisted(_account);
    }

    /// @notice Unblacklist an account
    function _unblacklist(address _account) internal {
        getStorage()._blacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }
}
