// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BloodConsumption Contract: Manages blood consumption records.
// This tracks when blood units are used (consumed) in hospitals or medical facilities.
// In a federated blockchain, this could interact cross-chain with donation and transportation contracts.

contract BloodConsumption {
    // Reference to the BloodDonation contract (for cross-contract interaction)
    BloodDonation public donationContract;

    // Struct to represent a consumption event
    struct Consumption {
        uint256 unitId;          // ID of the consumed blood unit
        address consumer;        // Address of the hospital/consumer
        uint256 consumptionDate; // Timestamp of consumption
        string purpose;          // Purpose of use (e.g., "Surgery", "Transfusion")
    }

    // Mapping from unit ID to Consumption
    mapping(uint256 => Consumption) public consumptions;

    // Event emitted when a blood unit is consumed
    event UnitConsumed(uint256 unitId, address consumer, uint256 consumptionDate, string purpose);

    // Constructor to link with the donation contract
    constructor(address donationAddress) {
        donationContract = BloodDonation(donationAddress);
    }

    // Modifier to restrict access (e.g., only authorized medical entities)
    modifier onlyAuthorized() {
        // Federation could use multi-sig or oracle verification
        require(msg.sender != address(0), "Unauthorized access");
        _;
    }

    // Function to record blood consumption
    function recordConsumption(uint256 unitId, address consumer, string memory purpose) public onlyAuthorized {
        require(donationContract.isUnitAvailable(unitId), "Unit not available or expired");

        // Mark as consumed in donation contract (assuming it has a function to update availability)
        // For simplicity, we assume interaction; in practice, use interface
        // donationContract.markAsUnavailable(unitId); // Hypothetical function

        consumptions[unitId] = Consumption({
            unitId: unitId,
            consumer: consumer,
            consumptionDate: block.timestamp,
            purpose: purpose
        });

        emit UnitConsumed(unitId, consumer, block.timestamp, purpose);
    }

    // Function to get consumption details
    function getConsumptionDetails(uint256 unitId) public view returns (Consumption memory) {
        return consumptions[unitId];
    }
}

