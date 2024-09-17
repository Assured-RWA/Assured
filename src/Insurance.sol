// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";
import "./CentralStorage.sol";

contract Insurance {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;

    CentralStorage centralStorage;

    AssuredLibrary.Property[] public pendingProperties;
    AssuredLibrary.Vehicle[] public pendingVehicles;

    mapping(uint => AssuredLibrary.Property) propertyIds;
    mapping(uint => AssuredLibrary.Vehicle) vehicleIds;

    constructor(address _centralStorage) {
        centralStorage = CentralStorage(_centralStorage);
    }

    modifier onlyPropertyInspector() {
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);
        require(inspector.valid, "you are Not an Inspector");
        require(inspector.assetType == 1, "you are Not a Property Inspector");
        _;
    }

    modifier onlyVehicleInspector() {
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);
        require(inspector.status, "you are Not an Inspector");
        require(inspector.assetType == 2, "you are Not a Vehicle Inspector");
        _;
    }

    function bookPropertyInspection(
        string memory _address
    ) public payable returns (bool) {
        require(msg.value == 100, "House inspection cost 100 wei");

        centralStorage.incrementPropertyId();
        AssuredLibrary.Property storage newProperty = propertyIds[
            centralStorage.returnPropertyId()
        ];
        newProperty.id = centralStorage.returnPropertyId();
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

        centralStorage.incrementVehicleId();
        AssuredLibrary.Vehicle storage newVehicle = vehicleIds[
            centralStorage.returnVehicleId()
        ];
        newVehicle.id = centralStorage.returnVehicleId();
        newVehicle.owner = msg.sender;
        newVehicle.assetType = "Vehicle";
        newVehicle.addr = _address;
        newVehicle.status = AssuredLibrary.InspectionStatus.pending;

        pendingVehicles.push(newVehicle);

        return true;
    }

    function inspectAVehicle(uint _vehicleId) public onlyVehicleInspector {
        AssuredLibrary.Vehicle storage vehicle = vehicleIds[_vehicleId];
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);

        require(
            vehicle.status == AssuredLibrary.InspectionStatus.pending,
            "Vehicle is not in need of Inspection"
        );
        vehicle.status = AssuredLibrary.InspectionStatus.inspecting;
        vehicle.inspector = msg.sender;

        inspector.currentlyInspecting = true;
        centralStorage.setInspector(inspector.inspector, inspector);
    }

    function inspectAHouse(uint _propertyId) public onlyPropertyInspector {
        AssuredLibrary.Property storage property = propertyIds[_propertyId];
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);

        require(
            property.status == AssuredLibrary.InspectionStatus.pending,
            "Property is not in need of Inspection"
        );
        property.status = AssuredLibrary.InspectionStatus.inspecting;
        property.inspector = msg.sender;
        inspector.currentlyInspecting = true;
        centralStorage.setInspector(inspector.inspector, inspector);
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
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);
        asset.assetLocation = _location;
        asset.ageOfAsset = _age;
        asset.categoryofAsset = _type;
        asset.safetyFeatures = _protection;
        asset.status = AssuredLibrary.InspectionStatus.inspected;
        asset.propertyValue = _propertyValue;
        uint premium = AssuredLibrary.calculatePropertyInsurancePremium(
            _location,
            _type,
            _age,
            _protection,
            _propertyValue
        ); // call the function to calculate the premium

        asset.premium = premium;
        inspector.currentlyInspecting = false;
        inspector.assetInspected++;

        address recipient = inspector.inspector;

        (bool success, ) = recipient.call{value: 75}("");
        require(success, "Transfer failed.");
        centralStorage.setInspector(inspector.inspector, inspector);
    }

    function returnPropertyOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Property storage newAsset = propertyIds[_assetId];
        return newAsset.owner;
    }

    function returnVehicleOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Vehicle storage newAsset = vehicleIds[_assetId];
        return newAsset.owner;
    }
}
