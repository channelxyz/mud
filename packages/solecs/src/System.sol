// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import { ISystem } from "./interfaces/ISystem.sol";
import { IUint256Component } from "./interfaces/IUint256Component.sol";
import { IWorld } from "./interfaces/IWorld.sol";

/**
 * System base contract
 */
abstract contract System is ISystem {
  IUint256Component components;
  IWorld world;
  address _owner;

  // Additions
  uint256 public readCounter;
  string[] public readComponentIds;
  mapping(string => address) public readComponentIdToAddress;

  uint256 public writeCounter;
  string[] public writeComponentIds;
  mapping(string => address) public writeComponentIdToAddress;

  uint256 public id;
  string public idString;

  modifier onlyOwner() {
    require(msg.sender == _owner, "ONLY_OWNER");
    _;
  }

  constructor(
    IWorld _world,
    address _components,
    string[] memory _readComponentsIds,
    address[] memory _readComponentsAddrs,
    string[] memory _writeComponentsIds,
    address[] memory _writeComponentsAddrs,
    string memory _idString
  ) {
    _owner = msg.sender;
    components = _components == address(0) ? _world.components() : IUint256Component(_components);
    world = _world;

    // Additions
    // Read components
    require(
      _readComponentsIds.length == _readComponentsAddrs.length,
      "InitSystem: readComponentsIds and readComponentsAddrs must have the same length"
    );
    readCounter = _readComponentsIds.length;
    readComponentIds = _readComponentsIds;
    for (uint256 i = 0; i < readCounter; i++) {
      readComponentIdToAddress[_readComponentsIds[i]] = _readComponentsAddrs[i];
    }

    // Written components
    require(
      _writeComponentsIds.length == _writeComponentsAddrs.length,
      "InitSystem: writeComponentsIds and writeComponentsAddrs must have the same length"
    );
    writeCounter = _writeComponentsIds.length;
    writeComponentIds = _writeComponentsIds;
    for (uint256 i = 0; i < writeCounter; i++) {
      writeComponentIdToAddress[_writeComponentsIds[i]] = _writeComponentsAddrs[i];
    }

    // System ID
    idString = _idString;
  }

  function owner() public view returns (address) {
    return _owner;
  }

  function getReadComponentIds() public view returns (string[] memory) {
    return readComponentIds;
  }

  function getWriteComponentIds() public view returns (string[] memory) {
    return writeComponentIds;
  }

  function getMetadataURL() public pure returns (string memory) {
    return "fakeURL";
  }
}
