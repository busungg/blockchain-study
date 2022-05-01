pragma solidity ^0.8.13;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;
  }
  
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns (uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);

    uint counter = 0;
    for(uint i = 0; i < zombies.length; i++) {
      if(zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }

    return result;
  }
}

/*
for 반복문을 써서 getZombiesByOwner 함수를 끝내보도록 하지. 
반복문 안에서는 우리 DApp 안에 있는 모든 좀비들에 접근하고, 
그들의 소유자가 우리가 찾는 자인지 비교하여 확인한 후, 조건에 맞는 좀비들을 result 배열에 추가한 후 반환할 것이네.

1. counter라는 이름의 uint를 하나 선언하고 0을 대입하게. 
우린 result 배열에서 인덱스를 추적하기 위해 이 변수를 사용할 것이네.

2. uint i = 0에서 시작해서 i < zombies.length까지 증가하는 for 반복문을 선언하게. 
이 반복문에서 우리 배열의 모든 좀비에 접근할 것이네.

3. for 반복문 안에서, zombieToOwner[i]가 _owner와 같은지 확인하는 if 문장을 만들게. 
이 문장은 두 개의 주소값이 같은지 비교하는 것이네.

if 문장 안에서:

result[counter]에 i를 대입해서 result 배열에 좀비의 ID를 추가하게.
counter를 1 증가시키게(위의 for 반복문 예시를 참고하게).
이게 끝이라네 - 이 함수는 이제 _owner가 소유한 모든 좀비를 가스를 소모하지 않고 반환하게 될 것이네.
 */