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
        // uint256 verificationPeriod;
        bool isVerified;
        uint256 verificationDate;
        Continent continent;
        InspectorStatus inspectorStatus;
    }

    struct InspectorDTO {
        address user;
        string name;
        bytes[3] documents;
        bytes location;
        Continent continent;
    }

    enum Continent {
        AFRICA,
        EUROPE,
        ASIA,
        ANTARTICA
    }
    // struct Inspectors {
    //     address inspector;
    //     bool valid;
    //     uint8 assetType;
    //     uint assetInspected;
    //     bool currentlyInspecting;
    //     bool status;
    //     uint inspectorId;
    // }

    enum InspectorStatus {
        REVIEW,
        APPROVED,
        BLACKLISTED
    }

    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }
}
