// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./AssuredLibrary.sol";

contract CentralStorage {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;

    uint256 public propertyId;
    uint256 public vehicleId;

    uint256 inspectorsId;
    address public daoAddress;

    AssuredLibrary.Property[] public pendingProperties;
    AssuredLibrary.Vehicle[] public pendingVehicles;

    mapping(uint256 => AssuredLibrary.Property) propertyIds;
    mapping(uint256 => AssuredLibrary.Vehicle) vehicleIds;
    mapping(address => AssuredLibrary.Inspectors) public inspectors;
    mapping(uint256 => uint256) public data; // Shared storage (can be any data structure)

    constructor(address _daoAddress) {
        daoAddress = _daoAddress;
    }

    function onlyDao() public view returns (address, address) {
        // require(msg.sender == daoAddress, "Only Owner can Perform this Action");
        // return (tx.origin, msg.sender);
        return (msg.sender, msg.sender);
    }

    // Function to set data
    function setInspector(address _address, AssuredLibrary.Inspectors memory _inspector) public {
        inspectors[_address] = _inspector;
        AssuredLibrary.Inspectors storage newInspector = inspectors[_address];
        newInspector.inspector = _address;
    }

    // Function to get data
    function getInspector(address _adddress) public view returns (AssuredLibrary.Inspectors memory _inspector) {
        return inspectors[_adddress];
    }

    function deleteInspector(address _inspector) public {
        delete inspectors[_inspector];
    }

    function incrementInspectorId() public {
        inspectorsId++;
    }

    function returnInspectorsId() public view returns (uint256) {
        return inspectorsId;
    }

    function incrementPropertyId() public {
        propertyId++;
    }

    function returnPropertyId() public view returns (uint256) {
        return propertyId;
    }

    function setProperty(AssuredLibrary.Property memory _property) public {
        propertyIds[propertyId] = _property;
    }

    function getProperty(uint256 _propertyId) public view returns (AssuredLibrary.Property memory _inspector) {
        return propertyIds[_propertyId];
    }

    function incrementVehicleId() public {
        vehicleId++;
    }

    function returnVehicleId() public view returns (uint256) {
        return vehicleId;
    }

    function setVehicle(AssuredLibrary.Vehicle memory _vehicle) public {
        vehicleIds[vehicleId] = _vehicle;
    }

    function getVehicle(uint256 _vehicleId) public view returns (AssuredLibrary.Vehicle memory _vehicle) {
        return vehicleIds[_vehicleId];
    }

    function pushProperty(AssuredLibrary.Property memory _propery) public {
        pendingProperties.push(_propery);
    }

    function pushVehicle(AssuredLibrary.Vehicle memory _vehicle) public {
        pendingVehicles.push(_vehicle);
    }

    function returnDaoAddress() public view returns (address) {
        return daoAddress;
    }
}
