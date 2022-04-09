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

/**
레슨 2에서 우리가 만든 코드를 크립토키티 컨트랙트 
주소의 업데이트가 가능하도록 바꿔보세.

1. 우리가 직접 주소를 써넣었던 ckAddress가 있는 줄을 지우게.

2. 우리가 kittyContract를 생성했던 줄을 변수 선언만 하도록 변경하게 - 
  어떤 것도 대입을 하지 않도록 하게.

3. setKittyContractAddress라는 이름의 함수를 생성하게. 
   이 함수는 address 타입의 변수 _address를 하나의 인자로 받고, 
   external 함수여야 하네.

4. 함수 내에서, kittyContract에 KittyInterface(_address)를 
   대입하는 한 줄의 코드를 작성하게.
*/