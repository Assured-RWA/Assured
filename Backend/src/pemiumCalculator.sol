// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// This contract calculates insurance premiums for property based on various risk factors like location, age, and protective measures.

contract PremiumCalculator {
    uint public assetIds;
    address owner = msg.sender;

    struct Inspectors {
        uint8 assetType;
        uint assetInspected;
        bool currentlyInspecting;
        bool status;
        address inspectee;
    }
    enum InspectionStatus {
        none,
        pending,
        inspecting,
        inspected
    }
    struct Asset {
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
    }

    Asset[] public pendingProperties;
    Asset[] public pendingVehicles;

    // struct Client {
    //     address addr;
    //     string asset;
    //     InspectionStatus status;
    // }

    // mapping(address => Client) clients;

    mapping(uint => Asset) assetId;
    mapping(address => Inspectors) inspectorss;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner can Perform this Action");
        _;
    }

    modifier onlyInspector() {
        Inspectors storage inspector = inspectorss[msg.sender];
        require(inspector.status, "you are Not an Inspector");
        _;
    }

    function bookInspection(uint8 _assetType) public payable returns (bool) {
        string memory assetType;
        if (_assetType == 1) {
            assetType = "House";
            require(msg.value == 100, "House inspection cost 100 wei");
        }

        if (_assetType == 2) {
            assetType = "Vehicle";
            require(msg.value == 50, "Vehicle inspection cost 50 wei");
        }
        assetIds++;
        Asset storage newAsset = assetId[assetIds];
        newAsset.id = assetIds;
        newAsset.owner = msg.sender;
        newAsset.assetType = assetType;
        newAsset.status = InspectionStatus.pending;
        if (_assetType == 1) {
            pendingProperties.push(newAsset);
        }

        if (_assetType == 2) {
            pendingVehicles.push(newAsset);
        }

        return true;
    }

    function inspectAVehicle(uint _vehicleId) public onlyInspector {
        Asset storage vehicle = assetId[_vehicleId];
        Inspectors storage inspector = inspectorss[msg.sender];

        require(inspector.assetType == 2, "You are not a Vehicle inspector");
        require(
            vehicle.status == InspectionStatus.pending,
            "Vehicle is not in need of Inspection"
        );
        vehicle.status = InspectionStatus.inspecting;
        vehicle.inspector = msg.sender;

        inspector.currentlyInspecting = true;
    }

    function inspectAHouse(uint _propertyId) public onlyInspector {
        Asset storage property = assetId[_propertyId];
        Inspectors storage inspector = inspectorss[msg.sender];

        require(inspector.assetType == 1, "You are not a property inspector");
        require(
            property.status == InspectionStatus.pending,
            "Property is not in need of Inspection"
        );
        property.status = InspectionStatus.inspecting;
        property.inspector = msg.sender;
        inspector.currentlyInspecting = true;
    }

    function submitPropertyInspectionResultAndGenerate(
        uint _assetId,
        uint _location,
        uint _age,
        uint _type,
        uint _protection,
        uint _propertyValue
    ) public onlyInspector {
        Asset storage asset = assetId[_assetId];
        Inspectors storage inspector = inspectorss[msg.sender];
        asset.assetLocation = _location;
        asset.ageOfAsset = _age;
        asset.categoryofAsset = _type;
        asset.safetyFeatures = _protection;
        asset.status = InspectionStatus.inspected;
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

        address recipient = inspector.inspectee;

        (bool success, ) = recipient.call{value: 75}("");
        require(success, "Transfer failed.");
    }

    function makeInspector(address addr, uint8 _type) public onlyOwner {
        Inspectors storage inspector = inspectorss[addr];
        inspector.inspectee = addr;
        inspector.assetType = _type;
        inspector.status = true;
    }

    function removeInspector(address addr) public onlyOwner {
        Inspectors storage inspector = inspectorss[addr];
        inspector.status = false;
    }

    function viewPendingVehiclesInspections()
        public
        view
        returns (Asset[] memory)
    {
        return pendingVehicles;
    }

    function viewPendingPropertiesInspections()
        public
        view
        returns (Asset[] memory)
    {
        return pendingProperties;
    }

    function viewAsset(uint _assetId) public view returns (Asset memory) {
        Asset storage newAsset = assetId[_assetId];
        return newAsset;
    }

    function assetOwner(uint _assetId) public view returns (address) {
        Asset storage newAsset = assetId[_assetId];
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

    function returnPremium(uint id) public view returns (uint) {
        Asset storage asset = assetId[id];
        return asset.premium;
    }
}
