pragma solidity ^0.8.13;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    
}

/**
자네를 위해 erc721.sol 파일을 인터페이스와 함께 만들어 놓았네.

erc721.sol 파일을 zombieownership.sol 파일에서 임포트하게.

ZombieOwnership이 ZombieAttack과 ERC721을 상속한다고 선언하게.
 */