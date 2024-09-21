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
    }

    struct InspectorDTO {
        address user;
        bytes name;
        bytes[3] documents;
        bytes location;
    }

    enum Continent {
        AFRICA, EUROPE, ASIA, ANTARTICA
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

    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }

    function convertStringToBytes(string memory input) internal pure returns (bytes memory) {
        return bytes(input);
    }

    function convertToLowerCase(string memory input) internal pure returns (string memory result) {
        bytes memory stringBytes = bytes(input);
        bytes memory lowerCaseBytes = new bytes(stringBytes.length);
        for (uint256 i = 0; i < stringBytes.length; i++) {
            // Convert to lowercase if character is uppercase
            if (stringBytes[i] >= 0x41 && stringBytes[i] <= 0x5A) {
                lowerCaseBytes[i] = bytes1(uint8(stringBytes[i]) + 32);
            } else {
                lowerCaseBytes[i] = stringBytes[i];
            }
        }
        result = string(lowerCaseBytes);
    }
}
