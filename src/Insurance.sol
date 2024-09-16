// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";

contract Insurance {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;
    uint public propertyId;
    uint public vehicleId;
    address daoAddress;

    AssuredLibrary.Property[] public pendingProperties;
    AssuredLibrary.Vehicle[] public pendingVehicles;

    mapping(uint => AssuredLibrary.Property) propertyIds;
    mapping(uint => AssuredLibrary.Vehicle) vehicleIds;
    mapping(address => AssuredLibrary.Inspectors) inspectorss;

    constructor(address _daoAddress) {
        daoAddress = _daoAddress;
    }

    modifier onlyDao() {
        require(msg.sender == daoAddress, "Only Owner can Perform this Action");
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
}
