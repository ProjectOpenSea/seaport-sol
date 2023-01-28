// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { CriteriaResolver, OfferItem } from "seaport/lib/ConsiderationStructs.sol";
import { Side } from "seaport/lib/ConsiderationEnums.sol";
import { ArrayLib } from "./ArrayLib.sol";

library CriteriaResolverLib {
    bytes32 private constant CRITERIA_RESOLVER_MAP_POSITION = keccak256("seaport.CriteriaResolverDefaults");

    using ArrayLib for bytes32[];
    /**
     * @notice clears a default CriteriaResolver from storage
     * @param defaultName the name of the default to clear
     */

    function clear(string memory defaultName) internal {
        mapping(string => CriteriaResolver) storage criteriaResolverMap = _criteriaResolverMap();
        CriteriaResolver storage resolver = criteriaResolverMap[defaultName];
        // clear all fields
        bytes32[] memory criteriaProof;
        resolver.orderIndex = 0;
        resolver.side = Side(0);
        resolver.index = 0;
        resolver.identifier = 0;
        ArrayLib.setBytes32s(resolver.criteriaProof, criteriaProof);
    }

    /**
     * @notice gets a default CriteriaResolver from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (CriteriaResolver memory resolver) {
        mapping(string => CriteriaResolver) storage criteriaResolverMap = _criteriaResolverMap();
        resolver = criteriaResolverMap[defaultName];
    }

    /**
     * @notice saves an CriteriaResolver as a named default
     * @param criteriaResolver the CriteriaResolver to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(CriteriaResolver memory criteriaResolver, string memory defaultName) internal {
        mapping(string => CriteriaResolver) storage criteriaResolverMap = _criteriaResolverMap();
        CriteriaResolver storage resolver = criteriaResolverMap[defaultName];
        resolver.orderIndex = criteriaResolver.orderIndex;
        resolver.side = criteriaResolver.side;
        resolver.index = criteriaResolver.index;
        resolver.identifier = criteriaResolver.identifier;
        ArrayLib.setBytes32s(resolver.criteriaProof, criteriaResolver.criteriaProof);
    }

    /**
     * @notice makes a copy of an CriteriaResolver in-memory
     * @param resolver the CriteriaResolver to make a copy of in-memory
     */
    function copy(CriteriaResolver memory resolver) internal pure returns (CriteriaResolver memory) {
        return CriteriaResolver({
            orderIndex: resolver.orderIndex,
            side: resolver.side,
            index: resolver.index,
            identifier: resolver.identifier,
            criteriaProof: resolver.criteriaProof.copy()
        });
    }

    function copy(CriteriaResolver[] memory resolvers) internal pure returns (CriteriaResolver[] memory) {
        CriteriaResolver[] memory copiedItems = new CriteriaResolver[](resolvers.length);
        for (uint256 i = 0; i < resolvers.length; i++) {
            copiedItems[i] = copy(resolvers[i]);
        }
        return copiedItems;
    }

    /**
     * @notice gets the storage position of the default CriteriaResolver map
     */
    function _criteriaResolverMap()
        private
        pure
        returns (mapping(string => CriteriaResolver) storage criteriaResolverMap)
    {
        bytes32 position = CRITERIA_RESOLVER_MAP_POSITION;
        assembly {
            criteriaResolverMap.slot := position
        }
    }

    // methods for configuring a single of each of an CriteriaResolver's fields, which modifies the CriteriaResolver
    // in-place and
    // returns it

    function setOrderIndex(
        CriteriaResolver memory resolver,
        uint256 orderIndex
    )
        internal
        pure
        returns (CriteriaResolver memory)
    {
        resolver.orderIndex = orderIndex;
        return resolver;
    }

    function setSide(CriteriaResolver memory resolver, Side side) internal pure returns (CriteriaResolver memory) {
        resolver.side = side;
        return resolver;
    }

    function setIndex(
        CriteriaResolver memory resolver,
        uint256 index
    )
        internal
        pure
        returns (CriteriaResolver memory)
    {
        resolver.index = index;
        return resolver;
    }

    function setIdentifier(
        CriteriaResolver memory resolver,
        uint256 identifier
    )
        internal
        pure
        returns (CriteriaResolver memory)
    {
        resolver.identifier = identifier;
        return resolver;
    }

    function setCriteriaProof(
        CriteriaResolver memory resolver,
        bytes32[] memory criteriaProof
    )
        internal
        pure
        returns (CriteriaResolver memory)
    {
        // todo: consider copying?
        resolver.criteriaProof = criteriaProof;
        return resolver;
    }
}
