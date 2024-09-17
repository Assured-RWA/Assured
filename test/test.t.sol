// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import {CentralStorage} from "../src/CentralStorage.sol";
import {Inspector} from "../src/Inspector.sol";
import {Insurance} from "../src/Insurance.sol";
import {Dao} from "../src/Dao.sol";

contract Premium is Test {
    CentralStorage public centralStorage;
    Inspector public inspector;
    Insurance public insurance;
    Dao public dao;

    address expectedOwner = address(this);
    address clientA = address(0xa);
    address clientB = address(0xb);
    address inspector1 = address(0xF);
    address vehicleInspector = address(0xAF);

    function setUp() public {
        vm.prank(expectedOwner);

        dao = new Dao();
        // address daoAddress = address(dao);
        centralStorage = new CentralStorage(clientA);
        address centralStorageAddress = address(centralStorage);
        inspector = new Inspector(centralStorageAddress);
        insurance = new Insurance(centralStorageAddress);
    }

    function test_Inspector() public {
        vm.prank(clientA);

        inspector.registerInspector(inspector1, 1);
        vm.prank(clientA);
        inspector.approveInspector(inspector1);
        inspector.suspendInspector(inspector1);
        inspector.returnInspectorStatus(inspector1);
    }

    function test_bookPropertyInspection(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(insurance);
        insurance.bookPropertyInspection{value: 100}("Narayi");
        assertEq(insurance.returnPropertyOwner(1), clientA);
        uint256 balance = address(contractAddress).balance;
        assertEq(balance, 100 wei);
    }

    function test_bookVehicleInspection(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(insurance);
        insurance.bookVehicleInspection{value: 50}(
            "Narayi",
            120,
            5,
            25,
            50000,
            0
        );
        assertEq(insurance.returnVehicleOwner(1), clientA);
        uint256 balance = address(contractAddress).balance;
        assertEq(balance, 50 wei);
    }

    function test_generatePropertyPremium(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.deal(clientB, 1000 wei);
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(insurance);
        insurance.bookPropertyInspection{value: 100}("Narayi");
        vm.prank(expectedOwner);

        inspector.registerInspector(inspector1, 1);
        vm.prank(clientA);
        inspector.approveInspector(inspector1);

        inspector.returnInspectorStatus(inspector1);

        vm.prank(inspector1);
        insurance.inspectAHouse(1);
        inspector.returnInspectorStatus(inspector1);
        vm.prank(inspector1);
        insurance.submitPropertyInspectionResultAndGenerate(
            1,
            80,
            3,
            150,
            1,
            5000
        );

        uint256 contractBalance = address(contractAddress).balance;
        uint256 inspectorBalance = address(inspector1).balance;
        assertEq(contractBalance, 25 wei);
        assertEq(inspectorBalance, 75 wei);

        vm.prank(clientB); // Set msg.sender for the next transaction
        insurance.bookPropertyInspection{value: 100}("Barnawa");
        vm.prank(inspector1);
        insurance.inspectAHouse(2);
        inspector.returnInspectorStatus(inspector1);
        vm.prank(inspector1);
        insurance.submitPropertyInspectionResultAndGenerate(
            1,
            60,
            8,
            130,
            1,
            8000
        );
        insurance.returnPropertyOwner(1);
        insurance.returnPropertyOwner(2);

        uint256 contractBalance1 = address(contractAddress).balance;
        uint256 inspectorBalance1 = address(inspector1).balance;

        assertEq(contractBalance1, 50 wei);
        assertEq(inspectorBalance1, 150 wei);
    }

    function test_generateVehiclePremium(uint) public {
        vm.deal(clientA, 1000 wei); // Fund the caller with 1 ether (or sufficient amount)
        vm.deal(clientB, 1000 wei);
        vm.prank(clientA); // Set msg.sender for the next transaction
        address contractAddress = address(insurance);
        insurance.bookVehicleInspection{value: 50}(
            "Narayi",
            120,
            5,
            25,
            20000,
            1
        );
        vm.prank(expectedOwner);

        inspector.registerInspector(inspector1, 2);
        vm.prank(clientA);
        inspector.approveInspector(inspector1);

        inspector.returnInspectorStatus(inspector1);

        vm.prank(inspector1);
        insurance.inspectAVehicle(1);
        inspector.returnInspectorStatus(inspector1);
        vm.prank(inspector1);
        insurance.submitVehicleInspectionResultAndGenerate(1, 10);

        uint256 contractBalance = address(contractAddress).balance;
        uint256 inspectorBalance = address(inspector1).balance;
        assertEq(contractBalance, 15 wei);
        assertEq(inspectorBalance, 35 wei);

        vm.prank(clientB); // Set msg.sender for the next transaction
        insurance.bookVehicleInspection{value: 50}(
            "Barnawa",
            150,
            2,
            15,
            50000,
            0
        );
        vm.prank(clientA);
        inspector.approveInspector(inspector1);
        vm.prank(inspector1);
        insurance.inspectAVehicle(2);
        inspector.returnInspectorStatus(inspector1);
        vm.prank(inspector1);
        insurance.submitVehicleInspectionResultAndGenerate(2, 50);
        insurance.returnPropertyOwner(1);
        insurance.returnPropertyOwner(2);

        uint256 contractBalance1 = address(contractAddress).balance;
        uint256 inspectorBalance1 = address(inspector1).balance;

        assertEq(contractBalance1, 30 wei);
        assertEq(inspectorBalance1, 70 wei);
    }
}
