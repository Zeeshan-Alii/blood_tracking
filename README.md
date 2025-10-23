# blood_tracking

Contracts Included
BloodDonation.sol

Records donor details and blood unit metadata

Tracks availability and expiry of blood units

Emits events for donation logging

BloodTransportation.sol

Manages shipment of blood units between facilities

Tracks transport status and timestamps

Emits events for transport initiation and updates

BloodConsumption.sol

Logs consumption of blood units by authorized entities

Records purpose and timestamp of usage

Interfaces with BloodDonation for availability checks
