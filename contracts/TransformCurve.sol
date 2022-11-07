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
    using PRBMathSD59x18 for uint256;

    uint256 public N;

    uint256 constant SCALE = 1e18 * 2 * Trigonometry.PI; // scale to add to trig inputs so same output is expected

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

        for (uint256 i = 0; i < radii.length; i++) {
            for (uint256 j = 0; j < N; j++) {
                uint256 degrees = uint256(frequencies[i] * x[j] + phases[i]);
                int256 sine = Trigonometry.sin(degrees);

                y[j] += radii[i] * sine;
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

    function validateSin() 
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
            y[i] = Trigonometry.sin(uint256(x[i]));
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