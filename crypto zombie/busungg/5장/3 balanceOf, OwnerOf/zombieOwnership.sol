pragma solidity ^0.8.13;

import "./zombieattack.sol";
import "./erc721.sol";

contract ZombieOwnership is ZombieAttack, ERC721 {
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        // 1. 여기서 `_owner`가 가진 좀비의 수를 반환하게.
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        // 2. 여기서 `_tokenId`의 소유자를 반환하게.
        return zombieToOwner[_tokenId];
    }

    function transfer(address _to, uint256 _tokenId) public {

    }

    function approve(address _to, uint256 _tokenId) public {

    }

    function takeOwnership(uint256 _tokenId) public {

    }
}

/**
이 두 함수를 어떻게 구현할지 직접 생각하고 이해해 보게.

각각의 함수는 return을 쓰는 딱 1줄의 코드로만 구성되어야 하네. 
이전 레슨들에서 우리의 코드를 살펴보고 우리가 이 데이터들을 어디에 저장하는지 확인해보게. 찾기 너무 힘들다면, "정답 보기" 버튼을 눌러 도움을 받게.

1. _owner가 가진 좀비의 수를 반환하도록 balanceOf를 구현하게.

2. ID가 _tokenId인 좀비를 가진 주소를 반환하도록 ownerOf를 구현하게.
 */