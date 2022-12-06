// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

// Let you pause and unpause a contract
interface IPausable {
    
    /// @notice check if contract is paused
    function paused() external view returns (bool);

    /// @notice pause the contract
    function pause() external;

    /// @notice unpause the contract
    function unpause() external;
}
