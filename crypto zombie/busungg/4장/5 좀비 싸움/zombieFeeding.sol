pragma solidity ^0.8.13;

import "./zombiefactory.sol";

contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {
    KittyInterface kittyContract;

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        if(keccak256(_species) == keccak256("kitty")){
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}

/*
1. 현재 feedAndMultiply는 public 함수이네. 이걸 internal로 만들어서 컨트랙트가 더 안전해지도록 하세. 
우리는 사용자들이 그들이 원하는 아무 DNA나 넣어서 이 함수를 실행하는 것을 원하지 않네.

2. feedAndMultiply 함수가 cooldownTime을 고려하도록 만들어보세. 먼저, myZombie를 찾은 후에,
 _isReady()를 확인하는 require 문장을 추가하고 거기에 myZombie를 전달하게. 이렇게 하면 사용자들은 좀비의 재사용 대기 시간이 끝난 다음에만 이 함수를 실행할 수 있네.

3. 함수의 끝에서 _triggerCooldown(myZombie) 함수를 호출하여 먹이를 먹는 것이 좀비의 재사용 대기 시간을 만들도록 하게.
 */