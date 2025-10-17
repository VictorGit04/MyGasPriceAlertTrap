// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "contracts/interfaces/ITrap.sol";

contract MyGasPriceAlertTrap is ITrap {
    uint256 public constant MY_GAS_PRICE_LIMIT = 100 gwei;  // Set a gas price limit

    struct CollectOutput {
        uint256 currentMyGasPrice;
    }

    constructor() {}

    function collect() external view override returns (bytes memory) {
        return abi.encode(CollectOutput({currentMyGasPrice: tx.gasprice}));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
        if (current.currentMyGasPrice > MY_GAS_PRICE_LIMIT) return (true, bytes(""));
        return (false, bytes(""));
    }
}
