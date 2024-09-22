// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library InspectorObject {
    struct Inspector {
        uint256 id;
        bytes name;
        address inspectorAddress;
        bytes location;
        bytes[3] documents;
        uint256 registrationPeriod;
        bool isVerified;
        uint256 verificationDate;
        Continent continent;
        InspectorStatus inspectorStatus;
        InspectorSpecialization specialization;
    }

    struct InspectorDTO {
        address user;
        string name;
        bytes[3] documents;
        bytes location;
        Continent continent;
        InspectorSpecialization specialization;
    }

    enum Continent {
        AFRICA,
        EUROPE,
        ASIA,
        ANTARTICA
    }

    enum InspectorStatus {
        REVIEW,
        APPROVED,
        BLACKLISTED
    }

    enum InspectorSpecialization {
        NIL, 
        VEHICLE,
        PROPERTY
    }

    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }
}
