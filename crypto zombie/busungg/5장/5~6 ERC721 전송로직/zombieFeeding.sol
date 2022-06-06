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

    modifier onlyOwnerOf(uint _zombieId) {
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

    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) internal onlyOwnerOf(_zombieId){
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
zombiefeeding.sol로 돌아와서, 
우리의 modifier의 이름을 ownerOf에서 onlyOwnerOf로 바꿀 것이네.

제어자를 정의하는 이름을 onlyOwnerOf로 바꾸게.

이 제어자를 사용하는 feedAndMultiply 함수로 스크롤을 내리게. 여기서도 그 이름을 바꿔야 할 것이네.

참고: 우리는 이 제어자를 zombiehelper.sol과 zombieattack.sol에서도 사용하네. 
하지만 우리는 이 레슨에서 리팩토링에 시간을 너무 많이 쓰지는 않도록 할 것이야. 
그래서 내가 자네를 위해 이 파일들에서 제어자의 이름을 먼저 변경해 놓았네.
 */