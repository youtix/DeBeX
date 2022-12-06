// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/**
 * @notice Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 */
library LibPausable {

    bytes32 constant PAUSABLE_POSITION = keccak256("debex.pause.storage");
    struct PausableStorage {
        bool _paused;
    }
    function getStorage() internal pure returns (PausableStorage storage pausableStorage) {
        bytes32 position = PAUSABLE_POSITION;
        assembly {
            pausableStorage.slot := position
        }
    }

    /// @notice Emitted when the pause is triggered by `account`.
    event Paused(address account);

    /// @notice Emitted when the pause is lifted by `account`.
    event Unpaused(address account);

    /// @notice Revert if the contract is not paused.
    function _revertIfUnpaused() internal view {
        require(getStorage()._paused, "Pausable: contract already unpaused");
    }

    /// @notice Revert if the contract is paused.
    function _revertIfPaused() internal view {
        require(!getStorage()._paused, "Pausable: contract already paused");
    }
    
    /// @notice Pause the contract.
    function _pause() internal {
        PausableStorage storage _storage = getStorage();
        _storage._paused = true;
        emit Paused(msg.sender);
    }
    
    /// @notice Unpause the contract.
    function _unpause() internal {
        PausableStorage storage _storage = getStorage();
        _storage._paused = false;
        emit Unpaused(msg.sender);
    }
}
