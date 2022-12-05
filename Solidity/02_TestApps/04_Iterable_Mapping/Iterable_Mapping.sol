// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library IterableMapping {

    struct Map {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }

    function get(Map storage map, address key) public view returns (uint) {
        return map.values[key];
    }

    function getKeyAtIndexMap(Map storage map, uint index) public view returns(address) {
        return map.keys[index];
    }

    function size(Map storage map) public view returns(uint) {
        return map.keys.length;
    }

    function set(Map storage map, address key, uint val) public {
        if(map.inserted[key]) {
           map.values[key]  = val;
        }
        else {
            map.values[key] = val;
            map.inserted[key] = true;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }

    function remove(Map storage map, address key) public {
        if(!map.inserted[key]) {
            return;
        }

        delete map.inserted[key];
        delete map.values[key];

        uint idx = map.indexOf[key];
        uint lastIdx = map.keys.length - 1;
        address lastKey = map.keys[lastIdx];
        map.indexOf[lastKey] = idx;
        map.keys[idx] = lastKey;

        map.keys.pop();

        delete map.indexOf[key];
    }
}

contract TestIterableMapping {
    using IterableMapping for IterableMapping.Map;
    IterableMapping.Map private map;

    function testIterable() public returns(bool) {
        map.set(address(0), 0);
        map.set(address(1), 100);
        map.set(address(2), 200);
        map.set(address(2), 250);
        map.set(address(3), 400);

        assert(map.get(address(0)) == 0);
        assert(map.get(address(1)) == 100);
        assert(map.get(address(2)) == 250);
        assert(map.get(address(3)) == 400);

        map.remove(address(1));

        assert(map.size() == 3);

        assert(map.getKeyAtIndexMap(0) == address(0));
        assert(map.getKeyAtIndexMap(1) == address(3));
        assert(map.getKeyAtIndexMap(2) == address(2));

        return true;
    }
}