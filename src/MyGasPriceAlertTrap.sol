// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

/// @title MyGasPriceAlertTrap
/// @notice Example Drosera trap that triggers when basefee exceeds a threshold
contract MyGasPriceAlertTrap is ITrap {
    uint256 public constant MY_BASEFEE_LIMIT = 100 gwei; // Trigger threshold

    struct CollectOutput {
        uint256 currentBasefee;
    }

    constructor() {}

    /// @notice Called by Drosera to collect the signal
    function collect() external view override returns (bytes memory) {
        // Use block.basefee instead of tx.gasprice for stable reading
        return abi.encode(CollectOutput({currentBasefee: block.basefee}));
    }

    /// @notice Decide whether to respond based on collected history
    /// @dev Must not revert when `data` is empty (planner safety)
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length == 0) {
            // No data yet (planner call) → do nothing
            return (false, bytes(""));
        }

        // Decode the latest sample
        CollectOutput memory latest = abi.decode(data[data.length - 1], (CollectOutput));

        bool trigger = latest.currentBasefee > MY_BASEFEE_LIMIT;

        // Return both trigger and an ABI-encoded payload (optional: include measured value)
        return (trigger, abi.encode(latest.currentBasefee));
    }
}

