// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {
    BasicOrderParameters,
    OrderComponents,
    ConsiderationItem,
    OrderParameters,
    OfferItem,
    AdditionalRecipient
} from "seaport/lib/ConsiderationStructs.sol";
import { OrderType, ItemType, BasicOrderType } from "seaport/lib/ConsiderationEnums.sol";
import { StructCopier } from "./StructCopier.sol";

library OrderComponentsLib {
    using OrderComponentsLib for OrderComponents;

    bytes32 private constant OFFER_ITEM_MAP_POSITION = keccak256("seaport.OrderComponentsDefaults");

    function clear(OrderComponents storage components) internal {
        // uninitialized pointers take up no new memory (versus one word for initializing length-0)
        OfferItem[] memory offer;
        ConsiderationItem[] memory consideration;

        // clear all fields
        components.offerer = address(0);
        components.zone = address(0);
        StructCopier.setOfferItems(components.offer, offer);
        StructCopier.setConsiderationItems(components.consideration, consideration);
        components.orderType = OrderType(0);
        components.startTime = 0;
        components.endTime = 0;
        components.zoneHash = bytes32(0);
        components.salt = 0;
        components.conduitKey = bytes32(0);
        components.counter = 0;
    }

    /**
     * @notice clears a default OrderComponents from storage
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => OrderComponents) storage orderComponentsMap = _orderComponentsMap();
        OrderComponents storage components = orderComponentsMap[defaultName];
        components.clear();
    }

    function empty() internal pure returns (OrderComponents memory item) {
        OfferItem[] memory offer;
        ConsiderationItem[] memory consideration;
        item = OrderComponents({
            offerer: address(0),
            zone: address(0),
            offer: offer,
            consideration: consideration,
            orderType: OrderType(0),
            startTime: 0,
            endTime: 0,
            zoneHash: bytes32(0),
            salt: 0,
            conduitKey: bytes32(0),
            counter: 0
        });
    }

    /**
     * @notice gets a default OrderComponents from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (OrderComponents memory item) {
        mapping(string => OrderComponents) storage orderComponentsMap = _orderComponentsMap();
        item = orderComponentsMap[defaultName];
    }

    /**
     * @notice saves an OrderComponents as a named default
     * @param orderComponents the OrderComponents to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(OrderComponents memory orderComponents, string memory defaultName) internal {
        if (keccak256(bytes(defaultName)) == keccak256("empty")) {
            revert('Default "empty" is reserved, use empty()');
        }
        mapping(string => OrderComponents) storage orderComponentsMap = _orderComponentsMap();
        OrderComponents storage destination = orderComponentsMap[defaultName];
        StructCopier.setOrderComponents(destination, orderComponents);
    }

    /**
     * @notice makes a copy of an OrderComponents in-memory
     * @param item the OrderComponents to make a copy of in-memory
     */
    function copy(OrderComponents memory item) internal pure returns (OrderComponents memory) {
        return OrderComponents({
            offerer: item.offerer,
            zone: item.zone,
            offer: item.offer,
            consideration: item.consideration,
            orderType: item.orderType,
            startTime: item.startTime,
            endTime: item.endTime,
            zoneHash: item.zoneHash,
            salt: item.salt,
            conduitKey: item.conduitKey,
            counter: item.counter
        });
    }

    /**
     * @notice gets the storage position of the default OrderComponents map
     */
    function _orderComponentsMap()
        private
        pure
        returns (mapping(string => OrderComponents) storage orderComponentsMap)
    {
        bytes32 position = OFFER_ITEM_MAP_POSITION;
        assembly {
            orderComponentsMap.slot := position
        }
    }

    // methods for configuring a single of each of an in-memory OrderComponents's fields, which modifies the
    // OrderComponents in-memory and returns it

    function withOfferer(
        OrderComponents memory components,
        address offerer
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.offerer = offerer;
        return components;
    }

    function withZone(OrderComponents memory components, address zone) internal pure returns (OrderComponents memory) {
        components.zone = zone;
        return components;
    }

    function withOffer(
        OrderComponents memory components,
        OfferItem[] memory offer
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.offer = offer;
        return components;
    }

    function withConsideration(
        OrderComponents memory components,
        ConsiderationItem[] memory consideration
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.consideration = consideration;
        return components;
    }

    function withOrderType(
        OrderComponents memory components,
        OrderType orderType
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.orderType = orderType;
        return components;
    }

    function withStartTime(
        OrderComponents memory components,
        uint256 startTime
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.startTime = startTime;
        return components;
    }

    function withEndTime(
        OrderComponents memory components,
        uint256 endTime
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.endTime = endTime;
        return components;
    }

    function withZoneHash(
        OrderComponents memory components,
        bytes32 zoneHash
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.zoneHash = zoneHash;
        return components;
    }

    function withSalt(OrderComponents memory components, uint256 salt) internal pure returns (OrderComponents memory) {
        components.salt = salt;
        return components;
    }

    function withConduitKey(
        OrderComponents memory components,
        bytes32 conduitKey
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.conduitKey = conduitKey;
        return components;
    }

    function withCounter(
        OrderComponents memory components,
        uint256 counter
    )
        internal
        pure
        returns (OrderComponents memory)
    {
        components.counter = counter;
        return components;
    }

    function toOrderParameters(OrderComponents memory components)
        internal
        pure
        returns (OrderParameters memory parameters)
    {
        parameters.offerer = components.offerer;
        parameters.zone = components.zone;
        parameters.offer = components.offer;
        parameters.consideration = components.consideration;
        parameters.orderType = components.orderType;
        parameters.startTime = components.startTime;
        parameters.endTime = components.endTime;
        parameters.zoneHash = components.zoneHash;
        parameters.salt = components.salt;
        parameters.conduitKey = components.conduitKey;
        parameters.totalOriginalConsiderationItems = components.consideration.length;
    }

    function toBasicOrderParameters(OrderComponents memory components)
        internal
        pure
        returns (BasicOrderParameters memory parameters)
    {
        parameters.considerationToken = components.consideration[0].token;
        parameters.considerationIdentifier = components.consideration[0].identifierOrCriteria;
        parameters.considerationAmount = components.consideration[0].startAmount;
        parameters.offerer = payable(components.offerer);
        parameters.zone = components.zone;
        parameters.offerToken = components.offer[0].token;
        parameters.offerIdentifier = components.offer[0].identifierOrCriteria;
        parameters.offerAmount = components.offer[0].startAmount;

        // oh god
        if (uint256(components.offer[0].itemType) > 3) {
            revert("Basic orders cannot have criteria");
        }
        ItemType offerItemType = components.offer[0].itemType;
        if (parameters.considerationToken == address(0)) {
            if (components.orderType == OrderType.FULL_RESTRICTED) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC721_FULL_RESTRICTED;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC1155_FULL_RESTRICTED;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.PARTIAL_RESTRICTED) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC721_PARTIAL_RESTRICTED;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC1155_PARTIAL_RESTRICTED;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.FULL_OPEN) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC721_FULL_OPEN;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC1155_FULL_OPEN;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.PARTIAL_OPEN) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC721_PARTIAL_OPEN;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ETH_TO_ERC1155_PARTIAL_OPEN;
                } else {
                    revert("Invalid item type");
                }
            }
        } else {
            if (components.orderType == OrderType.FULL_RESTRICTED) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC721_FULL_RESTRICTED;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC1155_FULL_RESTRICTED;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.PARTIAL_RESTRICTED) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC721_PARTIAL_RESTRICTED;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC1155_PARTIAL_RESTRICTED;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.FULL_OPEN) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC721_FULL_OPEN;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC1155_FULL_OPEN;
                } else {
                    revert("Invalid item type");
                }
            } else if (components.orderType == OrderType.PARTIAL_OPEN) {
                if (offerItemType == ItemType.ERC721) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC721_PARTIAL_OPEN;
                } else if (offerItemType == ItemType.ERC1155) {
                    parameters.basicOrderType = BasicOrderType.ERC20_TO_ERC1155_PARTIAL_OPEN;
                } else {
                    revert("Invalid item type");
                }
            }
        }

        parameters.startTime = components.startTime;
        parameters.endTime = components.endTime;
        parameters.zoneHash = components.zoneHash;
        parameters.salt = components.salt;
        parameters.offererConduitKey = components.conduitKey;
        parameters.fulfillerConduitKey = bytes32(0);
        uint256 additionalLength = components.consideration.length - 1;
        parameters.totalOriginalAdditionalRecipients = additionalLength;

        AdditionalRecipient[] memory additionalRecipients = new AdditionalRecipient[](additionalLength);
        for (uint256 i = 0; i < additionalLength; i++) {
            ConsiderationItem memory considerationItem = components.consideration[i + 1];
            additionalRecipients[i] = AdditionalRecipient({
                recipient: payable(considerationItem.token),
                amount: considerationItem.startAmount
            });
        }
        parameters.additionalRecipients = additionalRecipients;

        // don't set signature
    }
}
