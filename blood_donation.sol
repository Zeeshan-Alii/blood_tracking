// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BloodDonation Contract: Manages blood donation records in a federated blockchain system.
// This contract tracks donors, donation events, and blood unit details.
// In a federated setup, this could be deployed on a permissioned chain for donor privacy.

contract BloodDonation {
    // Struct to represent a blood unit donated
    struct BloodUnit {
        uint256 unitId;          // Unique ID for the blood unit
        address donor;           // Address of the donor
        string bloodType;        // Blood type (e.g., "A+", "O-")
        uint256 donationDate;    // Timestamp of donation
        uint256 expiryDate;      // Expiry timestamp (e.g., 42 days for whole blood)
        bool isAvailable;        // Availability status
    }

    // Mapping from unit ID to BloodUnit
    mapping(uint256 => BloodUnit) public bloodUnits;
    uint256 public nextUnitId;  // Counter for next unit ID

    // Event emitted when a donation is recorded
    event DonationRecorded(uint256 unitId, address donor, string bloodType, uint256 donationDate);

    // Modifier to restrict access (e.g., only authorized blood banks in federated network)
    modifier onlyAuthorized() {
        // In a real federated system, integrate with identity management or consortium rules
        require(msg.sender != address(0), "Unauthorized access");
        _;
    }

    // Function to record a new blood donation
    function recordDonation(address donor, string memory bloodType, uint256 expiryDays) public onlyAuthorized {
        uint256 donationDate = block.timestamp;
        uint256 expiryDate = donationDate + (expiryDays * 1 days);

        bloodUnits[nextUnitId] = BloodUnit({
            unitId: nextUnitId,
            donor: donor,
            bloodType: bloodType,
            donationDate: donationDate,
            expiryDate: expiryDate,
            isAvailable: true
        });

        emit DonationRecorded(nextUnitId, donor, bloodType, donationDate);
        nextUnitId++;
    }

    // Function to check if a blood unit is available and not expired
    function isUnitAvailable(uint256 unitId) public view returns (bool) {
        BloodUnit memory unit = bloodUnits[unitId];
        return unit.isAvailable && block.timestamp < unit.expiryDate;
    }
}

