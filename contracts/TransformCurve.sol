// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import "@prb/math/contracts/PRBMathSD59x18.sol";

import { Trigonometry } from "./Trigonometry.sol";

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

contract TransformCurve is
    Ownable
{
    using Strings for uint256;

    uint256 public N;

    struct Circle {
        uint256 radius;
        uint256 frequency;
        uint256 phase;
    }

    constructor(
        uint256 _N
    ) {
        N = _N;
    }

    // Convert the above to Solidity without using rationals or complex numbers
    function getCurve(
          int256[] memory radii
        , int256[] memory frequencies
        , int256[] memory phases
    ) 
        public 
        view 
        returns (
              int256[] memory x
            , int256[] memory y
        ) 
    {
        x = linSpace(0, int256(2 * Trigonometry.PI));

        y = new int256[](N);

        for (uint256 i = 0; i < N; i++) {
            for (uint256 j = 0; j < radii.length; j++) {
                // Degrees that are provided by the circle
                int256 degrees = frequencies[j] * x[i] + phases[j];
                // Convert degrees to radians (range of 0 to 2pi) 
                uint256 radians = uint256(degrees) * Trigonometry.PI / 180;

                int256 sine = Trigonometry.sin(radians);

                y[i] += radii[j] * sine;
            }
        }
    }


    function linSpace(
          int256 start
        , int256 end
    ) 
        public 
        view 
        returns (
              int256[] memory x
        ) 
    {
        x = new int256[](N);

        for (uint256 i = 0; i < N; i++) {
            x[i] = start + (end - start) * int256(i) / (int256(N) - 1);
        }
    }

    function setN(
        uint256 _N
    ) 
        public 
        onlyOwner 
    {
        N = _N;
    }
}