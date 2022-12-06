// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/**
 * @notice Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 */
library LibOwnable {

    bytes32 constant OWNABLE_POSITION = keccak256("debex.ownership.storage");
    struct OwnableStorage {
        address _owner;
    }
    function getStorage() internal pure returns (OwnableStorage storage pausableStorage) {
        bytes32 position = OWNABLE_POSITION;
        assembly {
            pausableStorage.slot := position
        }
    }

    /// @notice Emitted when the ownership is transfered from `previousOwner` to `newOwner`.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @notice Returns the address of the current owner.
    function _owner() internal view returns (address) {
        OwnableStorage storage _storage = getStorage();
        return _storage._owner;
    }

    /// @notice Throws if the sender is not the owner.
    function _revertIfNotOwner() internal view {
        require(_owner() == msg.sender, "Ownable: caller is not the owner");
    }

    /// @notice Transfers ownership of the contract to a new account (`newOwner`).
    /// Internal function without access restriction.
    function _transferOwnership(address newOwner) internal {
        OwnableStorage storage _storage = getStorage();
        address oldOwner = _storage._owner;
        _storage._owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
