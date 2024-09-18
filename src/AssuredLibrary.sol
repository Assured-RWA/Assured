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
        uint inspectorId;
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
        bool paid;
    }

    struct Vehicle {
        uint id;
        address owner;
        address inspector;
        InspectionStatus status;
        uint safetyFeatures;
        uint vehicleValue;
        uint vehicleAge;
        uint premium;
        uint vehicleType;
        uint claimHistory;
        uint driverAge;
        string ownersAddress;
        bool paid;
    }

    function calculatePropertyInsurancePremium(
        uint location,
        uint propertyType,
        uint age,
        uint protections,
        uint propertyValue
    ) internal pure returns (uint) {
        // Base rate for scaling
        uint baseRate = 1;

        // Combine risk factors into a single step
        uint riskFactors = location + propertyType - protections + age;

        // Ensure propertyValue is valid and use it to scale the premium
        require(propertyValue > 0, "Property value must be greater than zero");

        // Calculate the premium in a single step, using a more appropriate scaling factor
        uint premium = (baseRate * riskFactors * propertyValue) / 10000;

        return premium;
    }

    function calculateVehicleInsurancePremium(
        uint vehicleType, // Type of vehicle
        uint vehicleAge, // Age of the vehicle in years
        uint driverAge, // Age of the driver
        uint safetyFeatures, // Number of safety features (a score / 100 determined by inspectors)
        uint vehicleValue, // Value of the vehicle
        uint claimHistory // Number of claims the driver has had
    ) internal pure returns (uint) {
        // Base rate for scaling, and safety feature discount
        uint baseRate = 2;

        // Risk factor calculation in one step
        uint riskFactors = (vehicleType * 10) +
            (vehicleAge * 5) +
            ((driverAge < 25 || driverAge > 70) ? 20 : 10) -
            (safetyFeatures * 3) +
            (claimHistory * 15);

        // Ensure vehicle value is valid to avoid division by zero
        require(vehicleValue > 0, "Vehicle value must be greater than zero");

        // Premium calculation in one step with a scaled divisor
        return (baseRate * riskFactors * vehicleValue) / 100000;
    }
}
