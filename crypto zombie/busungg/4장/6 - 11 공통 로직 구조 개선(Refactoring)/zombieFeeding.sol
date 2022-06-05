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

    modifier ownerOf(uint _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal ownerOf(_zombieId){
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
zombiefeeding.sol을 다시 보도록 하겠네. 저 내용을 처음으로 썼던 곳이니 말이야. 확인 부분을 그 부분만의 modifier로 만들어 구조를 개선하겠네.

1. modifier를 ownerOf라는 이름으로 만들게. 이 제어자는 _zombieId(uint)를 1개의 인수로 받을 것이네.

2. 제어자 내용에서는 msg.sender와 zombieToOwner[_zombieId]가 같은지 require로 확인하고, 함수를 실행해야 하네.
 제어자의 문법이 기억이 나지 않는다면 zombiehelper.sol을 참고하면 되네.

3. feedAndMultiply의 함수 정의 부분을 ownerOf 제어자를 사용하도록 바꾸게.

이제 modifier를 사용하게 됐으니, require(msg.sender == zombieToOwner[_zombieId]); 줄을 지워도 되네.
 */