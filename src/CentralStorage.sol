// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./AssuredLibrary.sol";

contract CentralStorage {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;

    uint public propertyId;
    uint public vehicleId;
    uint inspectorsId;
    address daoAddress;

    AssuredLibrary.Property[] public pendingProperties;
    AssuredLibrary.Vehicle[] public pendingVehicles;

    mapping(uint => AssuredLibrary.Property) propertyIds;
    mapping(uint => AssuredLibrary.Vehicle) vehicleIds;
    mapping(address => AssuredLibrary.Inspectors) inspectors;
    mapping(uint => uint) public data; // Shared storage (can be any data structure)

    constructor(address _daoAddress) {
        daoAddress = _daoAddress;
    }

    modifier onlyDao() {
        require(msg.sender == daoAddress, "Only Owner can Perform this Action");
        _;
    }

    // Function to set data
    function setInspector(
        address _address,
        AssuredLibrary.Inspectors memory _inspector
    ) public onlyDao {
        inspectors[_address] = _inspector;
    }

    // Function to get data
    function getInspector(
        address _adddress
    ) public view returns (AssuredLibrary.Inspectors memory _inspector) {
        return inspectors[_adddress];
    }

    function deleteInspector(address _inspector) public onlyDao {
        delete inspectors[_inspector];
    }

    function incrementInspectorId() public {
        inspectorsId++;
    }

    function returnInspectorsId() public view returns (uint) {
        return inspectorsId;
    }
}
