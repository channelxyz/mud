// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import "solecs/System.sol";
import { IWorld } from "solecs/interfaces/IWorld.sol";
import { IUint256Component } from "solecs/interfaces/IUint256Component.sol";
import { IComponent } from "solecs/interfaces/IComponent.sol";
import { getAddressById } from "solecs/utils.sol";

uint256 constant ID = uint256(keccak256("system.ComponentDev"));

contract ComponentDevSystem is System {
  constructor(
    IWorld _world,
    address _components,
    string[] memory _readComponentsIds,
    address[] memory _readComponentsAddrs,
    string[] memory _writeComponentsIds,
    address[] memory _writeComponentsAddrs,
    string memory _idString
  )
    System(
      _world,
      _components,
      _readComponentsIds,
      _readComponentsAddrs,
      _writeComponentsIds,
      _writeComponentsAddrs,
      _idString
    )
  {}

  function requirement(bytes memory) public view returns (bytes memory) {
    // NOTE: Make sure to not include this system in a production deployment, as anyone can change all component values
  }

  function execute(bytes memory arguments) public returns (bytes memory) {
    (uint256 componentId, uint256 entity, bytes memory value) = abi.decode(arguments, (uint256, uint256, bytes));
    IComponent c = IComponent(getAddressById(components, componentId));
    if (value.length == 0) {
      c.remove(entity);
    } else {
      c.set(entity, value);
    }
  }

  function executeTyped(
    uint256 componentId,
    uint256 entity,
    bytes memory value // If value has length 0, the component is removed
  ) public returns (bytes memory) {
    return execute(abi.encode(componentId, entity, value));
  }
}
