// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";

// This contract calculates insurance premiums for property based on various risk factors like location, age, and protective measures.

contract PremiumCalculator {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;
    uint public propertyId;
    uint public vehicleId;
    address owner = msg.sender;

    AssuredLibrary.Property[] public pendingProperties;
    AssuredLibrary.Vehicle[] public pendingVehicles;

    mapping(uint => AssuredLibrary.Property) propertyIds;
    mapping(uint => AssuredLibrary.Vehicle) vehicleIds;
    mapping(address => AssuredLibrary.Inspectors) inspectorss;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can Perform this Action");
        _;
    }

    modifier onlyPropertyInspector() {
        AssuredLibrary.Inspectors storage inspector = inspectorss[msg.sender];
        require(inspector.status, "you are Not an Inspector");
        require(inspector.assetType == 1, "you are Not a Property Inspector");
        _;
    }

    modifier onlyVehicleInspector() {
        AssuredLibrary.Inspectors storage inspector = inspectorss[msg.sender];
        require(inspector.status, "you are Not an Inspector");
        require(inspector.assetType == 2, "you are Not a Vehicle Inspector");
        _;
    }

    function bookPropertyInspection(
        string memory _address
    ) public payable returns (bool) {
        require(msg.value == 100, "House inspection cost 100 wei");

        propertyId++;
        AssuredLibrary.Property storage newProperty = propertyIds[propertyId];
        newProperty.id = propertyId;
        newProperty.owner = msg.sender;
        newProperty.assetType = "Property";
        newProperty.addr = _address;
        newProperty.status = AssuredLibrary.InspectionStatus.pending;

        pendingProperties.push(newProperty);

        return true;
    }

    function bookVehicleInspection(
        string memory _address
    ) public payable returns (bool) {
        require(msg.value == 50, "Vehicle inspection cost 50 wei");

        vehicleId++;
        AssuredLibrary.Vehicle storage newVehicle = vehicleIds[vehicleId];
        newVehicle.id = vehicleId;
        newVehicle.owner = msg.sender;
        newVehicle.assetType = "Vehicle";
        newVehicle.addr = _address;
        newVehicle.status = AssuredLibrary.InspectionStatus.pending;

        pendingVehicles.push(newVehicle);

        return true;
    }

    function inspectAVehicle(uint _vehicleId) public onlyVehicleInspector {
        AssuredLibrary.Vehicle storage vehicle = vehicleIds[_vehicleId];
        AssuredLibrary.Inspectors storage inspector = inspectorss[msg.sender];

        require(
            vehicle.status == AssuredLibrary.InspectionStatus.pending,
            "Vehicle is not in need of Inspection"
        );
        vehicle.status = AssuredLibrary.InspectionStatus.inspecting;
        vehicle.inspector = msg.sender;

        inspector.currentlyInspecting = true;
    }

    function inspectAHouse(uint _propertyId) public onlyPropertyInspector {
        AssuredLibrary.Property storage property = propertyIds[_propertyId];
        AssuredLibrary.Inspectors storage inspector = inspectorss[msg.sender];

        require(
            property.status == AssuredLibrary.InspectionStatus.pending,
            "Property is not in need of Inspection"
        );
        property.status = AssuredLibrary.InspectionStatus.inspecting;
        property.inspector = msg.sender;
        inspector.currentlyInspecting = true;
    }

    function submitPropertyInspectionResultAndGenerate(
        uint _propertyId,
        uint _location,
        uint _age,
        uint _type,
        uint _protection,
        uint _propertyValue
    ) public onlyPropertyInspector {
        AssuredLibrary.Property storage asset = propertyIds[_propertyId];
        AssuredLibrary.Inspectors storage inspector = inspectorss[msg.sender];
        asset.assetLocation = _location;
        asset.ageOfAsset = _age;
        asset.categoryofAsset = _type;
        asset.safetyFeatures = _protection;
        asset.status = AssuredLibrary.InspectionStatus.inspected;
        asset.propertyValue = _propertyValue;
        uint premium = calculatePropertyInsurancePremium(
            _location,
            _type,
            _age,
            _protection,
            _propertyValue
        ); // call the function to calculate the premium

        asset.premium = premium;
        inspector.currentlyInspecting = false;

        address recipient = inspector.inspector;

        (bool success, ) = recipient.call{value: 75}("");
        require(success, "Transfer failed.");
    }

    function makeInspector(address addr, uint8 _type) public onlyOwner {
        AssuredLibrary.Inspectors storage inspector = inspectorss[addr];
        inspector.inspector = addr;
        inspector.assetType = _type;
        inspector.status = true;
    }

    function removeInspector(address addr) public onlyOwner {
        AssuredLibrary.Inspectors storage inspector = inspectorss[addr];
        inspector.status = false;
    }

    function viewPendingVehiclesInspections()
        public
        view
        returns (AssuredLibrary.Vehicle[] memory)
    {
        return pendingVehicles;
    }

    function viewPendingPropertiesInspections()
        public
        view
        returns (AssuredLibrary.Property[] memory)
    {
        return pendingProperties;
    }

    function viewProperty(
        uint _assetId
    ) public view returns (AssuredLibrary.Property memory) {
        AssuredLibrary.Property storage newAsset = propertyIds[_assetId];
        return newAsset;
    }

    function viewVehicle(
        uint _assetId
    ) public view returns (AssuredLibrary.Vehicle memory) {
        AssuredLibrary.Vehicle storage newAsset = vehicleIds[_assetId];
        return newAsset;
    }

    function returnPropertyOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Property storage newAsset = propertyIds[_assetId];
        return newAsset.owner;
    }

    function returnVehicleOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Vehicle storage newAsset = vehicleIds[_assetId];
        return newAsset.owner;
    }

    function calculatePropertyInsurancePremium(
        uint location,
        uint propertyType,
        uint age,
        uint protections,
        uint propertyValue
    ) public pure returns (uint) {
        // Adjusted base rate to make the calculations more reasonable
        uint baseRate = 1; // Lower base rate for better scaling

        // Risk factors
        uint locationRisk = location; // Location risk should be a reasonable value
        uint typeRisk = propertyType; // Property type risk should be scaled appropriately
        uint protectionDiscount = protections; // Protection discounts
        uint ageAdjustment = age; // Age adjustment (consider capping this value if it grows too large)

        // Calculate premium
        uint riskFactors = locationRisk +
            typeRisk +
            protectionDiscount +
            ageAdjustment;
        uint premium = baseRate * riskFactors;

        // Ensure propertyValue is not zero to avoid division by zero
        require(propertyValue > 0, "Property value must be greater than zero");

        // Adjust premium based on property value with a more reasonable divisor
        premium = (premium * propertyValue) / 10000; // Adjusted divisor for better scaling

        // Ensure the premium is non-negative
        return premium;
    }

    function returnInspectorStatus(
        address inspector
    ) public view returns (bool) {
        return inspectorss[inspector].status;
    }

    function returnPropertyPremium(uint id) public view returns (uint) {
        AssuredLibrary.Property storage asset = propertyIds[id];
        return asset.premium;
    }
}
