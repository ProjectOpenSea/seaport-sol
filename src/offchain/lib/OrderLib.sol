// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Order, AdvancedOrder, OrderParameters } from "seaport/lib/ConsiderationStructs.sol";
import { OrderParametersLib } from "./OrderParametersLib.sol";

library OrderLib {
    bytes32 private constant ORDER_MAP_POSITION = keccak256("seaport.OrderDefaults");

    using OrderParametersLib for OrderParameters;

    /**
     * @notice clears a default Order from storage
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => Order) storage orderMap = _orderMap();
        Order storage item = orderMap[defaultName];
        // clear all fields
        item.parameters.clear();
        item.signature = "";
    }

    /**
     * @notice gets a default Order from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (Order memory item) {
        mapping(string => Order) storage orderMap = _orderMap();
        item = orderMap[defaultName];
    }

    /**
     * @notice saves an Order as a named default
     * @param order the Order to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(Order memory order, string memory defaultName) internal {
        mapping(string => Order) storage orderMap = _orderMap();
        orderMap[defaultName] = order;
    }

    /**
     * @notice makes a copy of an Order in-memory
     * @param item the Order to make a copy of in-memory
     */
    function copy(Order memory item) internal pure returns (Order memory) {
        return Order({parameters: item.parameters.copy(), signature: item.signature});
    }

    function copy(Order[] memory items) internal pure returns (Order[] memory) {
        Order[] memory copiedItems = new Order[](items.length);
        for (uint256 i = 0; i < items.length; i++) {
            copiedItems[i] = copy(items[i]);
        }
        return copiedItems;
    }

    /**
     * @notice gets the storage position of the default Order map
     */
    function _orderMap() private pure returns (mapping(string => Order) storage orderMap) {
        bytes32 position = ORDER_MAP_POSITION;
        assembly {
            orderMap.slot := position
        }
    }

    // methods for configuring a single of each of an Order's fields, which modifies the Order in-place and
    // returns it

    function withParameters(
        Order memory order,
        OrderParameters memory parameters
    )
        internal
        pure
        returns (Order memory)
    {
        order.parameters = parameters.copy();
        return order;
    }

    function withSignature(Order memory order, bytes memory signature) internal pure returns (Order memory) {
        order.signature = signature;
        return order;
    }

    function toAdvancedOrder(
        Order memory order,
        uint120 numerator,
        uint120 denominator,
        bytes memory extraData
    )
        internal
        pure
        returns (AdvancedOrder memory advancedOrder)
    {
        advancedOrder.parameters = order.parameters.copy();
        advancedOrder.numerator = numerator;
        advancedOrder.denominator = denominator;
        advancedOrder.signature = order.signature;
        advancedOrder.extraData = extraData;
    }
}
