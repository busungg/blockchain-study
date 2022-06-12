pragma solidity ^0.8.13;

import "./zombieHelper.sol";

contract ZombieAttack is ZombieHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint){
        randNonce = randNonce.add(1);
        return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];
        uint rand = randMod(100);

        if(rand <= attackVictoryProbability) {
            myZombie.winCount = myZombie.winCount.add(1);
            myZombie.level = myZombie.level.add(1);
            enemyZombie.lossCount = enemyZombie.lossCount.add(1);
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount = myZombie.lossCount.add(1);
            enemyZombie.winCount = enemyZombie.winCount.add(1);
        }

        _triggerCooldown(myZombie);
    }
}

/*
좋아, 이제 우리의 DApp에서 사용한 모든 uint 타입에 대해 SafeMath를 적용할 수 있네!

ZombieAttack에서 이 모든 잠재적 문젯거리들을 고쳐보도록 하지(ZombieHelper에서도 고쳐져야 할 zombies[_zombieId].level++; 이런 부분이 있었지만, 우리가 이걸 하기 위해 추가적으로 챕터를 쓰지 않도록 내가 자네를 위해 처리해 놓았네 😉).

직접 해보기
어서 ZombieAttack에서 ++ 증가 부분을 SafeMath 메소드로 구성하게. 찾기 쉽도록 주석들을 달아놓았네.
*/