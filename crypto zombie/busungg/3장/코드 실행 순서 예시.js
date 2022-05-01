function _isReady(_zombie) {
  return _zombie.readyTime <= Date.now();
}

function feedAndMultiply(_zombieId, _targetDna, _species) {
  if (1 != 1) {
    throw new Exception("is not same address");
  }

  var myZombie = {
    dna: 1,
    readyTime: Date.now(),
  };

  if (!_isReady(myZombie)) {
    throw new Exception("is not ready");
  }

  _targetDna = _targetDna % 10;
  var newDna = (myZombie.dna + _targetDna) / 2;
}

feedAndMultiply(1, 1, 1);
