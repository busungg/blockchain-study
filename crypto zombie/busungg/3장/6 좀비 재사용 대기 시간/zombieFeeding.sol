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

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;

        if(keccak256(_species) == keccak256("kitty")){
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName", newDna);
    }

    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}

/*
1. _triggerCooldown을 정의하면서 시작하지. 이 함수는 1개의 인수로 Zombie storage 포인터 타입인 _zombie를 받네. 이 함수는 internal이어야 하네.

2. 함수의 내용에서는 _zombie.readyTime을 uint32(now + cooldownTime)으로 설정해야 하네.

3. 다음으로, _isReady라고 불리는 함수를 만들게. 이 함수 역시 _zombie라는 이름의 Zombie storage 타입 인수를 받네. internal view여야 하고, bool을 리턴해야 하네.

4. 함수의 내용에서는 (_zombie.readyTime <= now)를 리턴해야 하고, 이는 true 아니면 false로 계산될 것이네. 이 함수는 우리에게 좀비가 먹이를 먹은 후 충분한 시간이 지났는지 알려줄 것이네.

 */