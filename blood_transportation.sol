// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BloodTransportation Contract: Manages transportation of blood units.
// This tracks shipments, locations, and status updates for blood units in transit.
// In a federated system, use oracles or cross-chain bridges for real-time tracking.

contract BloodTransportation {
    // Reference to the BloodDonation contract
    BloodDonation public donationContract;

    // Enum for transportation status
    enum Status { Pending, InTransit, Delivered, Failed }

    // Struct to represent a transportation event
    struct Transport {
        uint256 unitId;          // ID of the blood unit being transported
        address transporter;     // Address of the transporter entity
        string fromLocation;     // Starting location (e.g., "Blood Bank A")
        string toLocation;       // Destination (e.g., "Hospital B")
        uint256 startTime;       // Timestamp when transport started
        uint256 endTime;         // Timestamp when transport ended
        Status status;           // Current status
    }

    // Mapping from unit ID to Transport
    mapping(uint256 => Transport) public transports;

    // Event emitted when transport starts
    event TransportStarted(uint256 unitId, address transporter, string fromLocation, string toLocation, uint256 startTime);
    // Event emitted when status updates
    event StatusUpdated(uint256 unitId, Status newStatus, uint256 updateTime);

    // Constructor to link with the donation contract
    constructor(address donationAddress) {
        donationContract = BloodDonation(donationAddress);
    }

    // Modifier to restrict access (e.g., only logistics partners in federation)
    modifier onlyAuthorized() {
        require(msg.sender != address(0), "Unauthorized access");
        _;
    }

    // Function to start transportation
    function startTransport(uint256 unitId, address transporter, string memory fromLocation, string memory toLocation) public onlyAuthorized {
        require(donationContract.isUnitAvailable(unitId), "Unit not available");

        transports[unitId] = Transport({
            unitId: unitId,
            transporter: transporter,
            fromLocation: fromLocation,
            toLocation: toLocation,
            startTime: block.timestamp,
            endTime: 0,
            status: Status.InTransit
        });

        emit TransportStarted(unitId, transporter, fromLocation, toLocation, block.timestamp);
    }

    // Function to update status (e.g., Delivered)
    function updateStatus(uint256 unitId, Status newStatus) public onlyAuthorized {
        Transport storage transport = transports[unitId];
        require(transport.status == Status.InTransit, "Invalid status transition");

        if (newStatus == Status.Delivered || newStatus == Status.Failed) {
            transport.endTime = block.timestamp;
        }
        transport.status = newStatus;

        emit StatusUpdated(unitId, newStatus, block.timestamp);
    }

    // Function to get transport details
    function getTransportDetails(uint256 unitId) public view returns (Transport memory) {
        return transports[unitId];
    }
}
