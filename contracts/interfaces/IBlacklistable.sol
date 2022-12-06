// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.0;

/// @notice Allows accounts to be blacklisted by a "blacklister" role
interface IBlacklistable {

    /**
     * @notice Checks if account is blacklisted
     * @param _account The address to check
     */
    function isBlacklisted(address _account) external view returns (bool);

    /**
     * @notice Adds account to blacklist
     * @param _account The address to blacklist
     */
    function blacklist(address _account) external;

    /**
     * @notice Removes account from blacklist
     * @param _account The address to remove from the blacklist
     */
    function unBlacklist(address _account) external;

    /**
     * @notice Update the blacklister address
     * @param _newBlacklister The new blacklister address
     */
    function updateBlacklister(address _newBlacklister) external;
}
