// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssuredLibrary.sol";
import "./CentralStorage.sol";

contract Insurance {
    using AssuredLibrary for AssuredLibrary.Inspectors;
    using AssuredLibrary for AssuredLibrary.Property;
    using AssuredLibrary for AssuredLibrary.InspectionStatus;

    CentralStorage centralStorage;

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
        require(inspector.valid, "you are Not an Inspector");
        require(inspector.assetType == 2, "you are Not a Vehicle Inspector");
        _;
    }

    function bookPropertyInspection(
        string memory _address
    ) public payable returns (bool) {
        require(msg.value == 100, "House inspection cost 100 wei");

        centralStorage.incrementPropertyId();
        AssuredLibrary.Property memory newProperty = centralStorage.getProperty(
            centralStorage.returnPropertyId()
        );
        newProperty.id = centralStorage.returnPropertyId();
        newProperty.owner = msg.sender;
        newProperty.assetType = "Property";
        newProperty.addr = _address;
        newProperty.status = AssuredLibrary.InspectionStatus.pending;

        centralStorage.setProperty(newProperty);
        centralStorage.pushProperty(newProperty);

        return true;
    }

    function bookVehicleInspection(
        string memory _address,
        uint _vehicleType,
        uint _vehicleAge,
        uint _driverAge,
        uint _vehicleValue,
        uint _claimHistory
    ) public payable returns (bool) {
        require(msg.value == 50, "Vehicle inspection cost 50 wei");

        centralStorage.incrementVehicleId();
        AssuredLibrary.Vehicle memory newVehicle = centralStorage.getVehicle(
            centralStorage.returnVehicleId()
        );
        newVehicle.id = centralStorage.returnVehicleId();
        newVehicle.owner = msg.sender;

        newVehicle.ownersAddress = _address;
        newVehicle.owner = msg.sender;
        newVehicle.status = AssuredLibrary.InspectionStatus.pending;
        newVehicle.vehicleType = _vehicleType;
        newVehicle.vehicleAge = _vehicleAge;
        newVehicle.driverAge = _driverAge;
        newVehicle.vehicleValue = _vehicleValue;
        newVehicle.claimHistory = _claimHistory;
        centralStorage.setVehicle(newVehicle);
        centralStorage.pushVehicle(newVehicle);

        return true;
    }

    function inspectAVehicle(uint _vehicleId) public onlyVehicleInspector {
        AssuredLibrary.Vehicle memory vehicle = centralStorage.getVehicle(
            _vehicleId
        );
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
        centralStorage.setVehicle(vehicle);
    }

    function inspectAHouse(uint _propertyId) public onlyPropertyInspector {
        AssuredLibrary.Property memory property = centralStorage.getProperty(
            _propertyId
        );
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
        centralStorage.setProperty(property);
    }

    function submitPropertyInspectionResultAndGenerate(
        uint _propertyId,
        uint _location,
        uint _age,
        uint _type,
        uint _protection,
        uint _propertyValue
    ) public onlyPropertyInspector {
        AssuredLibrary.Property memory asset = centralStorage.getProperty(
            _propertyId
        );
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
        centralStorage.setProperty(asset);
    }

    function submitVehicleInspectionResultAndGenerate(
        uint _vehicleId,
        uint _safetyFeatures
    ) public onlyVehicleInspector {
        AssuredLibrary.Vehicle memory vehicle = centralStorage.getVehicle(
            _vehicleId
        );
        AssuredLibrary.Inspectors memory inspector = centralStorage
            .getInspector(msg.sender);

        vehicle.safetyFeatures = _safetyFeatures;
        vehicle.status = AssuredLibrary.InspectionStatus.inspected;

        uint premium = AssuredLibrary.calculateVehicleInsurancePremium(
            vehicle.vehicleType,
            vehicle.vehicleAge,
            vehicle.driverAge,
            _safetyFeatures,
            vehicle.vehicleValue,
            vehicle.claimHistory
        ); // call the function to calculate the premium
        vehicle.premium = premium;
        inspector.currentlyInspecting = false;
        inspector.assetInspected++;

        address recipient = inspector.inspector;

        (bool success, ) = recipient.call{value: 35}("");
        require(success, "Transfer failed.");
        centralStorage.setInspector(inspector.inspector, inspector);
        centralStorage.setVehicle(vehicle);
    }

    function payPropertyInsurance(uint _propertyId) public payable {
        AssuredLibrary.Property memory asset = centralStorage.getProperty(
            _propertyId
        );
        // require(msg.value == asset.premium, "Insufficient funds.");
        require(!asset.paid, "not expired");

        asset.paid = true;
        centralStorage.setProperty(asset);
    }

    function payVehicleInsurance(uint _vehicle) public payable {
        AssuredLibrary.Vehicle memory asset = centralStorage.getVehicle(
            _vehicle
        );
        // require(msg.value == asset.premium, "Insufficient funds.");
        require(!asset.paid, "not expired");

        asset.paid = true;
        centralStorage.setVehicle(asset);
    }

    function getPropertyPremium(uint _propertyId) public view returns (uint) {
        AssuredLibrary.Property memory asset = centralStorage.getProperty(
            _propertyId
        );
        require(
            asset.owner == returnPropertyOwner(_propertyId),
            "Not your asset"
        );
        return asset.premium;
    }

    function getVehiclePremium(uint _vehicleId) public view returns (uint) {
        AssuredLibrary.Vehicle memory asset = centralStorage.getVehicle(
            _vehicleId
        );
        require(
            asset.owner == returnVehicleOwner(_vehicleId),
            "Not your asset"
        );
        return asset.premium;
    }

    function returnPropertyOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Property memory asset = centralStorage.getProperty(
            _assetId
        );
        return asset.owner;
    }

    function returnVehicleOwner(uint _assetId) public view returns (address) {
        AssuredLibrary.Vehicle memory asset = centralStorage.getVehicle(
            _assetId
        );
        return asset.owner;
    }

    function returnDaoAddress() public view returns (address) {
        return centralStorage.returnDaoAddress();
    }
}
