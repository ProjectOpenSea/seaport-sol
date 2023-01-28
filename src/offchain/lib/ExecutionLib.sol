// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Execution, ReceivedItem } from "seaport/lib/ConsiderationStructs.sol";
import { ReceivedItemLib } from "./ReceivedItemLib.sol";

library ExecutionLib {
    bytes32 private constant EXECUTION_MAP_POSITION = keccak256("seaport.ExecutionDefaults");

    using ReceivedItemLib for ReceivedItem;
    using ReceivedItemLib for ReceivedItem[];

    /**
     * @notice clears a default Execution from storage
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => Execution) storage executionMap = _executionMap();
        Execution storage item = executionMap[defaultName];
        // clear all fields
        item.item = ReceivedItemLib.empty();
        item.offerer = address(0);
        item.conduitKey = bytes32(0);
    }

    /**
     * @notice gets a default Execution from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (Execution memory item) {
        mapping(string => Execution) storage executionMap = _executionMap();
        item = executionMap[defaultName];
    }

    /**
     * @notice saves an Execution as a named default
     * @param execution the Execution to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(Execution memory execution, string memory defaultName) internal {
        mapping(string => Execution) storage executionMap = _executionMap();
        executionMap[defaultName] = execution;
    }

    /**
     * @notice makes a copy of an Execution in-memory
     * @param item the Execution to make a copy of in-memory
     */
    function copy(Execution memory item) internal pure returns (Execution memory) {
        return Execution({item: item.item.copy(), offerer: item.offerer, conduitKey: item.conduitKey});
    }

    function copy(Execution[] memory item) internal pure returns (Execution[] memory) {
        Execution[] memory copies = new Execution[](item.length);
        for (uint256 i = 0; i < item.length; i++) {
            copies[i] = copy(item[i]);
        }
        return copies;
    }

    /**
     * @notice gets the storage position of the default Execution map
     */
    function _executionMap() private pure returns (mapping(string => Execution) storage executionMap) {
        bytes32 position = EXECUTION_MAP_POSITION;
        assembly {
            executionMap.slot := position
        }
    }

    // methods for configuring a single of each of an Execution's fields, which modifies the Execution
    // in-place and
    // returns it

    function withItem(Execution memory execution, ReceivedItem memory item) internal pure returns (Execution memory) {
        execution.item = item.copy();
        return execution;
    }

    function withOfferer(Execution memory execution, address offerer) internal pure returns (Execution memory) {
        execution.offerer = offerer;
        return execution;
    }

    function withConduitKey(Execution memory execution, bytes32 conduitKey) internal pure returns (Execution memory) {
        execution.conduitKey = conduitKey;
        return execution;
    }
}
