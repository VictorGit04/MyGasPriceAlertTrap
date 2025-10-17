# GasPriceAlertTrap (Drosera Proof-of-Concept)

## Overview
This trap monitors the Ethereum gas prices and alerts when the gas price exceeds a specified limit, which is critical for managing transaction costs effectively.

---

## What It Does
* Monitors the current gas price on the Ethereum network.
* Triggers if the gas price exceeds 100 gwei, allowing users to take action accordingly.
* It demonstrates the essential Drosera trap pattern using deterministic logic.

---

## Key Files
* `src/GasPriceAlertTrap.sol` - The core trap contract containing the monitoring logic.
* `src/SimpleResponder.sol` - The required external response contract.
* `drosera.toml` - The deployment and configuration file.

---

## Detection Logic

The trap's core monitoring logic is contained in the deterministic `shouldRespond()` function.

solidity
function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
    CollectOutput memory current = abi.decode(data[0], (CollectOutput));
    CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
    if (current.currentGasPrice > GAS_PRICE_LIMIT) return (true, bytes(""));
    return (false, bytes(""));
}


---

## 🧪 Implementation Details and Key Concepts
* **Monitoring Target:** Watching the gas prices on the Ethereum network.
* **Deterministic Logic:** The `shouldRespond()` function uses the `pure` modifier, ensuring it is executed off-chain by operators to achieve consensus before a transaction is proposed.
* **Calculation/Thresholds:** The function checks if the current gas price exceeds the fixed threshold of 100 gwei.
* **Response Mechanism:** On trigger, the trap calls the external Responder contract, demonstrating the separation of monitoring and action.

---

## Test It
To verify the trap logic using Foundry, run the following command (assuming a test file has been created):

bash
forge test --match-contract GasPriceAlertTrap
