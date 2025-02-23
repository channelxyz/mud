// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;
import "solecs/BareComponent.sol";

contract AddressBareComponent is BareComponent {
  constructor(
    address world,
    uint256 id,
    string memory idString
  ) BareComponent(world, id, idString) {}

  function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
    keys = new string[](1);
    values = new LibTypes.SchemaValue[](1);

    keys[0] = "value";
    values[0] = LibTypes.SchemaValue.UINT256;
  }

  function set(uint256 entity, address value) public {
    set(entity, abi.encode(value));
  }

  function getValue(uint256 entity) public view returns (address) {
    address value = abi.decode(getRawValue(entity), (address));
    return value;
  }
}
