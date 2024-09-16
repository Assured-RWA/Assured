// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AssuredLibrary {
    struct Inspectors {
        address inspector;
        bool valid;
        uint8 assetType;
        uint assetInspected;
        bool currentlyInspecting;
        bool status;
    }

    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }

    struct Property {
        uint id;
        address owner;
        address inspector;
        InspectionStatus status;
        string assetType;
        uint assetLocation;
        uint categoryofAsset;
        uint ageOfAsset;
        uint safetyFeatures;
        uint propertyValue;
        uint premium;
        string addr;
    }

    struct Vehicle {
        uint id;
        address owner;
        address inspector;
        InspectionStatus status;
        string assetType;
        uint assetLocation;
        uint categoryofAsset;
        uint ageOfAsset;
        uint safetyFeatures;
        uint propertyValue;
        uint premium;
        string addr;
    }

    // // Example function for updating a struct
    // function updateStruct(
    //     MyStruct storage myStruct,
    //     string memory _name,
    //     uint _age
    // ) internal {
    //     myStruct.name = _name;
    //     myStruct.age = _age;
    // }

    // // Example function for calculating something
    // function calculateSomething(uint _a, uint _b) internal pure returns (uint) {
    //     return _a + _b;
    // }
}
