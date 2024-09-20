// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

library AssuredLibrary {
    struct Inspectors {
        address inspector;
        bool valid;
        uint8 assetType;
        uint256 assetInspected;
        bool currentlyInspecting;
        bool status;
        uint256 inspectorId;
    }

    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }

    struct Property {
        uint256 id;
        address owner;
        address inspector;
        InspectionStatus status;
        string assetType;
        uint256 assetLocation;
        uint256 categoryofAsset;
        uint256 ageOfAsset;
        uint256 safetyFeatures;
        uint256 propertyValue;
        uint256 premium;
        string addr;
        bool paid;
    }

    struct Vehicle {
        uint256 id;
        address owner;
        address inspector;
        InspectionStatus status;
        uint256 safetyFeatures;
        uint256 vehicleValue;
        uint256 vehicleAge;
        uint256 premium;
        uint256 vehicleType;
        uint256 claimHistory;
        uint256 driverAge;
        string ownersAddress;
        bool paid;
    }

    function calculatePropertyInsurancePremium(
        uint256 location,
        uint256 propertyType,
        uint256 age,
        uint256 protections,
        uint256 propertyValue
    ) internal pure returns (uint256) {
        // Base rate for scaling
        uint256 baseRate = 1;

        // Combine risk factors into a single step
        uint256 riskFactors = location + propertyType - protections + age;

        // Ensure propertyValue is valid and use it to scale the premium
        require(propertyValue > 0, "Property value must be greater than zero");

        // Calculate the premium in a single step, using a more appropriate scaling factor
        uint256 premium = (baseRate * riskFactors * propertyValue) / 10000;

        return premium;
    }

    function calculateVehicleInsurancePremium(
        uint256 vehicleType, // Type of vehicle
        uint256 vehicleAge, // Age of the vehicle in years
        uint256 driverAge, // Age of the driver
        uint256 safetyFeatures, // Number of safety features (a score / 100 determined by inspectors)
        uint256 vehicleValue, // Value of the vehicle
        uint256 claimHistory // Number of claims the driver has had
    ) internal pure returns (uint256) {
        // Base rate for scaling, and safety feature discount
        uint256 baseRate = 2;

        // Risk factor calculation in one step
        uint256 riskFactors = (vehicleType * 10) + (vehicleAge * 5) + ((driverAge < 25 || driverAge > 70) ? 20 : 10)
            - (safetyFeatures * 3) + (claimHistory * 15);

        // Ensure vehicle value is valid to avoid division by zero
        require(vehicleValue > 0, "Vehicle value must be greater than zero");

        // Premium calculation in one step with a scaled divisor
        return (baseRate * riskFactors * vehicleValue) / 100000;
    }
}
